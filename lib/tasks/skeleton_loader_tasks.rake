# frozen_string_literal: true

namespace :skeleton_loader do
  desc "Build JavaScript for all targets"
  task build_js: :environment do
    # Run webpack build
    system("yarn build")

    # Ensure assets/javascripts exists
    FileUtils.mkdir_p("app/assets/javascripts")

    # Copy webpack build to asset pipeline
    FileUtils.cp(
      "dist/skeleton-loader.js",
      "app/assets/javascripts/skeleton_loader.js"
    )

    puts "✓ Built successfully!"
    puts "  → Source: app/javascript/"
    puts "  → NPM build: dist/skeleton-loader.js"
    puts "  → Asset Pipeline: app/assets/javascripts/skeleton_loader.js"
  end
end
