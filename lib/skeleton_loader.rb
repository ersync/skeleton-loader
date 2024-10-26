# frozen_string_literal: true
require "skeleton_loader/version"
require "skeleton_loader/configuration"
require "skeleton_loader/engine"

require 'action_view'

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