module SkeletonLoader
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