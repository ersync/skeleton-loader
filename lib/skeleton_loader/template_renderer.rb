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

      config = SkeletonLoader.configuration.to_h
      @options = config.merge(options)

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
  end
end
