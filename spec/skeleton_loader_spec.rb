# frozen_string_literal: true

RSpec.describe SkeletonLoader do
  describe ".configuration" do
    it "returns a Configuration instance" do
      expect(described_class.configuration).to be_a(SkeletonLoader::Configuration)
    end
  end

  describe ".configure" do
    it "yields the Configuration instance to the block" do
      expect { |b| described_class.configure(&b) }.to yield_with_args(described_class.configuration)
    end
  end

  describe ".reset" do
    it "resets the configuration to a new instance" do
      original_config = described_class.configuration
      described_class.reset
      expect(described_class.configuration).not_to eq(original_config)
    end
  end

  describe SkeletonLoader::Error do
    it "is a subclass of StandardError" do
      expect(described_class.ancestors).to include(StandardError)
    end
  end
end
