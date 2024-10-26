require 'spec_helper'

RSpec.describe SkeletonLoader::Configuration do
  let(:configuration) { described_class.new }

  describe 'default values' do
    it 'sets default layout values' do
      expect(configuration.width).to eq('100%')
      expect(configuration.height).to eq('auto')
      expect(configuration.item_count).to eq(1)
      expect(configuration.target_display_type).to eq('block')
    end

    it 'sets default style values' do
      expect(configuration.background_color).to eq('#e0e0e0')
      expect(configuration.highlight_color).to eq('#f0f0f0')
      expect(configuration.border_radius).to eq('4px')
    end

    it 'sets default animation values' do
      expect(configuration.animation_enabled).to be true
      expect(configuration.animation_duration).to eq('1.5s')
      expect(configuration.animation_type).to eq('shine')
    end

    it 'sets default spacing values' do
      expect(configuration.padding).to eq('10px')
      expect(configuration.margin).to eq('0')
      expect(configuration.gap).to eq('10px')
    end

    it 'sets default content values' do
      expect(configuration.content_variant).to eq('text')
      expect(configuration.variant).to eq('default')
      expect(configuration.template_paths).to eq([])
      expect(configuration.aria_label).to eq('Loading content')
    end
  end

  describe '#to_h' do
    it 'converts configuration to hash' do
      hash = configuration.to_h
      expect(hash).to be_a(Hash)
      expect(hash[:width]).to eq('100%')
      expect(hash[:animation_enabled]).to be true
      expect(hash[:template_paths]).to eq([])
    end
  end
end