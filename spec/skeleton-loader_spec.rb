# rubocop:disable Naming/FileName
# frozen_string_literal: true

require "spec_helper"

RSpec.describe "SkeletonLoader::Bridge" do
  it "successfully requires the skeleton_loader file" do
    expect do
      require "skeleton-loader"
    end.not_to raise_error
  end
end
# rubocop:enable Naming/FileName
