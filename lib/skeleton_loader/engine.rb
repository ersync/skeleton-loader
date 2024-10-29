# frozen_string_literal: true

module SkeletonLoader
  # SkeletonLoader::Engine integrates the SkeletonLoader gem with Rails,
  # configuring asset paths, precompiling assets, and including view helpers
  # in Action View.
  class Engine < ::Rails::Engine
    isolate_namespace SkeletonLoader

    initializer "skeleton_loader.assets" do |app|
      app.config.assets.paths << root.join("app", "assets", "javascripts")
      app.config.assets.paths << root.join("app", "assets", "stylesheets")
      app.config.assets.precompile += %w[skeleton_loader.css skeleton_loader.js]
    end

    initializer "skeleton_loader.view_helpers" do
      ActiveSupport.on_load(:action_view) do
        include SkeletonLoader::ViewHelpers
      end
    end
  end
end
