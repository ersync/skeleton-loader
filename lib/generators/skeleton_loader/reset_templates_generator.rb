module SkeletonLoader
  module Generators
    class ResetTemplatesGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "Resets SkeletonLoader templates to default"

      def reset_templates
        directory ".", "app/views/skeleton_loader", force: true
      end
    end
  end
end