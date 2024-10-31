# frozen_string_literal: true

module SkeletonLoader
  #
  # This class handles rendering templates for skeleton loaders. It retrieves
  # template files and prepares them for display as placeholders.
  #
  class TemplateRenderer
    def self.render(template_path, options = {})
      new(template_path, options).render
    end

    def initialize(template_path, options = {})
      @template_path = template_path

      template_name = extract_template_name(template_path)

      config = SkeletonLoader.configuration.to_h
      template_defaults = SkeletonLoader::TemplateDefaults.for_template(template_name)

      @options = config.merge(template_defaults).merge(options)

      @options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def render
      template = File.read(@template_path)
      erb = ERB.new(template)
      result = erb.result(binding)
      ActionController::Base.new.helpers.raw(result)
    end

    private

    def extract_template_name(path)
      filename = File.basename(path, ".*")
      filename = filename.delete_prefix("_")
      filename.split(".").first
    end
  end
end
