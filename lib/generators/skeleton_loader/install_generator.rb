module SkeletonLoader
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)
      desc "Installs SkeletonLoader default templates and configuration"

      def copy_templates
        directory ".", "app/views/skeleton_loader"
      end

      def create_initializer
        template "initializer.rb", "config/initializers/skeleton_loader.rb"
      end
    end
  end
end
