# frozen_string_literal: true

require_relative "lib/skeleton_loader/version"

Gem::Specification.new do |spec|
  spec.name = "skeleton-loader"
  spec.version = SkeletonLoader::VERSION
  spec.authors = ["Emad Rahimi"]
  spec.email = ["121079771+ersync@users.noreply.github.com"]
  spec.summary = "A Ruby on Rails gem for skeleton loading screens."
  spec.description = "Provides customizable, responsive skeleton loaders for Rails views."
  spec.homepage = "https://github.com/ersync/skeleton-loader"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  # Metadata for RubyGems
  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ersync/skeleton-loader"
  spec.metadata["changelog_uri"] = "https://github.com/ersync/skeleton-loader/blob/main/CHANGELOG.md"

  # Files to be included in the gem
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.require_paths = ["lib"]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }

  # Dependencies
  spec.add_dependency "rails", ">= 5.0.0"

  # Development dependencies
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rubocop-rails"
  spec.add_development_dependency "rubocop-rspec"
end
