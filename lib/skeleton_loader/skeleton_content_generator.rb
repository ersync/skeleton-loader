# frozen_string_literal: true

module SkeletonLoader
  # Generates skeleton content based on a type, options, or a provided block.
  # Returns the block if given, renders a template if type is specified,
  # or defaults to "Loading..." if neither is provided.
  class SkeletonContentGenerator
    def self.generate(type: nil, options: {}, &block)
      if block_given?
        block
      elsif type
        template_path = TemplatePathFinder.find(type)
        raise Error, "No template found for type '#{type}'" unless template_path

        TemplateRenderer.render(template_path, options)
      else
        "Loading..."
      end
    end
  end
end
