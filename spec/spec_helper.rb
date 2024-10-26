# frozen_string_literal: true
ENV['RAILS_ENV'] ||= 'test'
require 'rails'
require 'action_controller'
require 'rails/generators'
require "skeleton_loader"
require "pry"

RSpec.configure do |config|
  config.example_status_persistence_file_path = ".rspec_status"
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end