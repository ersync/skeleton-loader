# frozen_string_literal: true

module SkeletonLoader
  # Creates a loading skeleton based on a specified type and target ID,
  # using templates or custom blocks for content.
  class SkeletonBuilder
    def initialize(type:, content_id:, options: {}, block: nil)
      @type = type
      @content_id = content_id
      @options = options
      @block = block
    end

    def generate
      validate_content_id!

      skeleton_content = generate_content
      wrap_content(skeleton_content)
    end

    private

    attr_reader :type, :content_id, :options, :block

    def validate_content_id!
      raise SkeletonLoader::Error, "content_id is required" if content_id.blank?
    end

    def generate_content
      if block
        block.is_a?(Proc) ? block.call : block
      else
        template_path = TemplatePathFinder.find(type)
        TemplateRenderer.render(template_path, options)
      end
    end

    def wrap_content(content)
      ActionController::Base.helpers.content_tag(:div, content,
                                                 class: "skeleton-loader",
                                                 style: "display:none;",
                                                 data: {
                                                   content_id: content_id
                                                 })
    end
  end
end
