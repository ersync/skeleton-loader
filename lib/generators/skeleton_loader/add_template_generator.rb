# frozen_string_literal: true

module SkeletonLoader
  module Generators
    # Copies default templates to app/views/skeleton_loader and
    # creates the necessary initializer file.
    class AddTemplateGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)
      desc "Installs SkeletonLoader default templates"

      def add_template
        directory ".", "app/views/skeleton_loader"
      end
    end
  end
end
