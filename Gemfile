# frozen_string_literal: true

source "https://rubygems.org"

# Specify your gem's dependencies in skeleton_loader.gemspec
gemspec

group :development do
  gem "rubocop", "~> 1.21"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "yard", "~> 0.9.26"
end

group :development, :test do
  gem "pry", "~> 0.14.2"
  gem "rake", "~> 13.0"
  gem "rspec_junit_formatter"
end

group :test do
  gem "rspec", "~> 3.0"
  gem "simplecov", "~> 0.22.0", require: false
end
