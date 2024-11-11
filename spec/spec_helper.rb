# frozen_string_literal: true

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

ENV["RAILS_ENV"] ||= "test"
require "rails"
require "action_controller"
require "action_view"
require "active_support/core_ext/string/inflections"
require "rails/generators"
require "skeleton_loader"
require "pry"
require File.expand_path("../app/controllers/skeleton_loader/skeleton_loader_controller", File.dirname(__FILE__))

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
