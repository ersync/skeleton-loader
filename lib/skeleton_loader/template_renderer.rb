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

      # Merge base configuration with user options
      config = SkeletonLoader.configuration.to_h
      @options = config.merge(options)

      # Set instance variables
      @options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def render
      template_content = File.read(@template_path)
      erb = ERB.new(template_content)
      template_binding = binding
      begin
        erb.result(template_binding)
      rescue StandardError => e
        raise "An error occurred while rendering the template located at #{@template_path}: #{e.message}"
      end
    end
  end
end
