# frozen_string_literal: true

RSpec.describe SkeletonLoader::Configuration do
  let(:configuration) { described_class.new }

  describe "default values" do
    it "sets the default layout width" do
      expect(configuration.width).to eq("100%")
    end

    it "sets the default layout height" do
      expect(configuration.height).to eq("auto")
    end

    it "sets the default item count in layout" do
      expect(configuration.item_count).to eq(1)
    end

    it "sets the default target display type for layout" do
      expect(configuration.target_display_type).to eq("block")
    end

    it "sets the default background color for style" do
      expect(configuration.background_color).to eq("#e0e0e0")
    end

    it "sets the default highlight color for style" do
      expect(configuration.highlight_color).to eq("#f0f0f0")
    end

    it "sets the default border radius for style" do
      expect(configuration.border_radius).to eq("4px")
    end

    it "enables animations by default" do
      expect(configuration.animation_enabled).to be true
    end

    it "sets the default animation duration" do
      expect(configuration.animation_duration).to eq("1.5s")
    end

    it "sets the default animation type" do
      expect(configuration.animation_type).to eq("animation-pulse")
    end

    it "sets the default padding for spacing" do
      expect(configuration.padding).to eq("10px")
    end

    it "sets the default margin for spacing" do
      expect(configuration.margin).to eq("0")
    end

    it "sets the default gap for spacing" do
      expect(configuration.gap).to eq("10px")
    end

    it "sets the default content variant" do
      expect(configuration.content_variant).to eq("text")
    end

    it "sets the default variant for content" do
      expect(configuration.variant).to eq("default")
    end

    it "sets the default template paths for content" do
      expect(configuration.template_paths).to eq([])
    end

    it "sets the default aria label for content" do
      expect(configuration.aria_label).to eq("Loading content")
    end
  end

  describe "#to_h" do
    it "converts the configuration to a hash" do
      expect(configuration.to_h).to be_a(Hash)
    end

    it "includes the correct width in the hash" do
      expect(configuration.to_h[:width]).to eq("100%")
    end

    it "includes the animation_enabled flag in the hash" do
      expect(configuration.to_h[:animation_enabled]).to be true
    end

    it "includes the correct template_paths in the hash" do
      expect(configuration.to_h[:template_paths]).to eq([])
    end
  end
end
