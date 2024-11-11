# frozen_string_literal: true

RSpec.describe SkeletonLoader::Engine, "#initialization" do
  it "inherits from Rails::Engine" do
    expect(described_class.ancestors).to include(Rails::Engine)
  end

  it "isolates the SkeletonLoader namespace" do
    expect(described_class.instance.class.isolated?).to be true
  end
end
