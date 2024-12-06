# frozen_string_literal: true

module SkeletonLoader
  # SkeletonLoader::Engine integrates the SkeletonLoader gem with Rails,
  # configuring asset paths, pre-compiling assets, and including view helpers
  # in Action View.
  class Engine < ::Rails::Engine
    isolate_namespace SkeletonLoader

    initializer "skeleton_loader.assets" do |app|
      # CSS always through asset pipeline
      app.config.assets.paths << root.join("app/assets/stylesheets")
      app.config.assets.precompile += %w[skeleton_loader.css]

      if defined?(Webpacker) || defined?(Shakapacker)
        # You should use npm package
      elsif defined?(Importmap::Engine)
        gem_js_path = root.join("app/assets/javascripts").to_s
        app.config.assets.paths.reject! { |path| path.to_s == gem_js_path }
        app.config.assets.paths << root.join("dist")
        app.config.assets.precompile += %w[skeleton_loader.js]
      else
        app.config.assets.paths << root.join("app/assets/javascripts")
        app.config.assets.precompile += %w[skeleton_loader.js]
      end
    end

    initializer "skeleton_loader.view_helpers" do
      ActiveSupport.on_load(:action_view) { include SkeletonLoader::ViewHelpers }
    end

    initializer "skeleton_loader.append_routes" do |app|
      app.routes.prepend do
        mount SkeletonLoader::Engine, at: "/skeleton_loader", as: "skeleton_loader_engine"
      end
    end

    initializer "skeleton_loader.append_migrations" do
      config.paths["app/controllers"] << File.expand_path("../app/controllers", __dir__)
    end
  end
end
