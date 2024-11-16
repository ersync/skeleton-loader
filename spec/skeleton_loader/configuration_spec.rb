# frozen_string_literal: true

RSpec.describe SkeletonLoader::Configuration do
  subject(:config) { described_class.new }

  describe "initialization" do
    it "sets default scale" do
      expect(config.scale).to eq(1.0)
    end

    it "sets empty template paths" do
      expect(config.template_paths).to eq([])
    end

    it "sets default animation type" do
      expect(config.animation_type).to eq("sl-gradient")
    end

    it "sets empty allowed tags" do
      expect(config.additional_allowed_tags).to eq([])
    end

    it "sets empty allowed attributes" do
      expect(config.additional_allowed_attributes).to eq({})
    end

    it "sets empty allowed CSS properties" do
      expect(config.additional_allowed_css_properties).to eq([])
    end
  end

  describe "default templates" do
    it "sets card template defaults" do
      expect(config.templates[:card]).to eq(width: 200, count: 3, per_row: 3)
    end

    it "sets comment template defaults" do
      expect(config.templates[:comment]).to eq(width: 900, count: 2, per_row: 1)
    end

    it "sets default template defaults" do
      expect(config.templates[:default]).to eq(width: 900, count: 1, per_row: 1)
    end
  end

  describe "#reset!" do
    before do
      config.instance_variable_set(:@scale, 2.0)
      config.instance_variable_set(:@animation_type, "custom")
      config.reset!
    end

    it "resets scale to default" do
      expect(config.scale).to eq(1.0)
    end

    it "resets animation type to default" do
      expect(config.animation_type).to eq("sl-gradient")
    end
  end

  describe "#base_options" do
    subject(:options) { config.base_options }

    it "includes correct scale" do
      expect(options[:scale]).to eq(1.0)
    end

    it "includes correct animation type" do
      expect(options[:animation_type]).to eq("sl-gradient")
    end

    it "includes empty allowed tags" do
      expect(options[:additional_allowed_tags]).to eq([])
    end
  end

  describe "#template_defaults_for" do
    it "returns card defaults for card type" do
      expect(config.template_defaults_for(:card))
        .to eq(width: 200, count: 3, per_row: 3)
    end

    it "returns default settings for nil type" do
      expect(config.template_defaults_for(nil))
        .to eq(width: 900, count: 1, per_row: 1)
    end

    it "returns default settings for unknown type" do
      expect(config.template_defaults_for(:unknown))
        .to eq(width: 900, count: 1, per_row: 1)
    end
  end
end
