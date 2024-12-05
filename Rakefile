# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
load "lib/tasks/skeleton_loader_tasks.rake"
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

task default: %i[spec rubocop]
