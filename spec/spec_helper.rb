# frozen_string_literal: true

# SimpleCov must be at the very top, before any other requires
require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
  enable_coverage :branch
  minimum_coverage line: 90, branch: 80

  add_group "Controllers", "app/controllers"
  add_group "Lib", "lib"
  add_group "Generators", "lib/generators"

  track_files "{app,lib}/**/*.rb"
end

# Rest of your requires after SimpleCov setup
ENV["RAILS_ENV"] ||= "test"
require "rails"
require "action_controller"
require "action_view"
require "active_support/core_ext/string/inflections"
require "rails/generators"
require "skeleton_loader"
require "pry"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
