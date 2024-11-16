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
      @options = merge_options(options)

      # Dynamically set instance variables for template rendering
      @options.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def render
      template_content = File.read(@template_path)
      erb = ERB.new(template_content)
      erb.result(binding)
    rescue StandardError => e
      raise "Error rendering template at #{@template_path}: #{e.message}"
    end

    private

    def merge_options(options)
      config = SkeletonLoader.configuration

      config.base_options
            .merge(config.template_defaults_for(options[:type]))
            .merge(options)
    end
  end
end
