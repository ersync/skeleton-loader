# frozen_string_literal: true

require "skeleton_loader/version"
require "skeleton_loader/configuration"
require "skeleton_loader/view_helpers"
require "skeleton_loader/template_path_finder"
require "skeleton_loader/skeleton_sanitizer"
require "skeleton_loader/template_renderer"
require "skeleton_loader/skeleton_element_generator"
require "skeleton_loader/engine"

require "action_view"

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
