# frozen_string_literal: true

require "skeleton_loader/version"
require "skeleton_loader/configuration"
require "skeleton_loader/view_helpers"
require "skeleton_loader/template_path_finder"
require "skeleton_loader/template_defaults"
require "skeleton_loader/template_renderer"
require "skeleton_loader/skeleton_element_generator"
require "skeleton_loader/engine"

require "action_view"

# This module serves as the entry point for the SkeletonLoader gem, which provides
# configurable skeleton loaders for Rails views. It includes configuration methods,
# custom error handling, and auto-loading for key classes and helpers.
#
# Usage:
# Configure by calling `SkeletonLoader.configure` and provide settings, such as
# template paths. SkeletonLoader provides view helpers and uses ActionView for
# generating HTML components for skeleton loaders.
#
module SkeletonLoader
  class Error < StandardError; end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration) if block_given?
  end

  def self.reset
    @configuration = Configuration.new
  end
end
