# frozen_string_literal: true

module SkeletonLoader
  # Generates a skeleton loader HTML element with content based on options or block
  class SkeletonElementGenerator
    class << self
      def generate(content_id:, options: {}, context: :view, &block)
        validate_content_id!(content_id)
        content = generate_content(options, &block)

        css_class = context == :controller ? "skeleton-loader--ajax" : "skeleton-loader--static"
        wrap_content(content, content_id, css_class)
      end

      private

      def validate_content_id!(content_id)
        raise SkeletonLoader::Error, "content_id is required" if content_id.blank?
      end

      def generate_content(options, &block)
        content = if block_given?
                    raise Error, "Options cannot be used with a block" unless options.empty?

                    block.call
                  else
                    type = options[:type] || "default"
                    template_path = TemplatePathFinder.find(type)
                    TemplateRenderer.render(template_path, options)
                  end

        SkeletonSanitizer.sanitize(content)
      end

      def wrap_content(content, content_id, css_class)
        ActionController::Base.helpers.content_tag(
          :div,
          content,
          class: css_class,
          data: { content_id: content_id }
        )
      end
    end
  end
end
