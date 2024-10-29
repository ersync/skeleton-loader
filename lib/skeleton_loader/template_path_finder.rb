# frozen_string_literal: true

module SkeletonLoader
  #
  # This class is responsible for locating a specific template file by type.
  # It searches through configured paths and defaults to searching in
  # `app/views/skeleton_loader` within the Rails root directory.
  # Raises an error if the template is not found.
  #
  class TemplatePathFinder
    def self.find(type)
      template_name = "_#{type}.html.erb"
      search_paths = SkeletonLoader.configuration.template_paths +
                     [Rails.root.join("app/views/skeleton_loader")]

      search_paths.each do |path|
        full_path = File.join(path, template_name)
        return full_path if File.exist?(full_path)
      end

      raise "Template '#{template_name}' not found in any of the specified paths."
    end
  end
end
