# frozen_string_literal: true

require_relative "lib/skeleton_loader/version"

Gem::Specification.new do |spec|
  spec.name = "skeleton-loader"
  spec.version = SkeletonLoader::VERSION
  spec.authors = ["Emad Rahimi"]
  spec.email = ["121079771+ersync@users.noreply.github.com"]

  spec.summary = "A Ruby on Rails gem for implementing skeleton loading screens to improve perceived performance."
  spec.description = "Skeleton-loader is a Ruby on Rails gem that provides an easy way to implement skeleton loading screens in your web applications. It helps improve the perceived performance of your app by displaying placeholder content while the actual data is being loaded. This gem offers customizable, responsive skeleton loaders that seamlessly integrate with Rails views and JavaScript frameworks."
  spec.homepage = "https://github.com/ersync/skeleton-loader"
  spec.license = "MIT"
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ersync/skeleton-loader"
  spec.metadata["changelog_uri"] = "https://github.com/ersync/skeleton-loader/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = Dir[
    "lib/**/*",
    "app/**/*",
    "config/**/*",
    "README.md",
    "LICENSE.txt"
  ]
  spec.require_paths = ["lib"]
  spec.add_dependency "rails", ">= 5.0.0"
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]


  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end