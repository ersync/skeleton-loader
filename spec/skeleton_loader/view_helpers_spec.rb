require 'spec_helper'
require 'action_view'
require 'action_controller'
require 'skeleton_loader/view_helpers'
require 'skeleton_loader/template_path_finder'
require 'skeleton_loader/template_renderer'

RSpec.describe SkeletonLoader::ViewHelpers do
  let(:helper_class) do
    Class.new do
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::CaptureHelper
      include SkeletonLoader::ViewHelpers
    end
  end
  let(:helper) { helper_class.new }

  before do
    allow(SkeletonLoader::TemplatePathFinder).to receive(:find).and_return('mock_template_path')

    allow(File).to receive(:read).with('mock_template_path').and_return('<div>Mock Template Content</div>')
  end

  describe '#skeleton_loader' do
    it 'raises error when target_id is nil' do
      expect { helper.skeleton_loader(target_id: nil) }
        .to raise_error(SkeletonLoader::Error, "target_id is required")
    end

    it 'raises error when target_id is empty' do
      expect { helper.skeleton_loader(target_id: '') }
        .to raise_error(SkeletonLoader::Error, "target_id is required")
    end

    it 'generates basic loader with default content' do
      result = helper.skeleton_loader(target_id: 'test-id')
      expect(result).to include('test-id')
      expect(result).to include('skeleton-loader')
      expect(result).to include('data-target-id="test-id"')
    end

    it 'generates loader with custom type' do
      result = helper.skeleton_loader('custom', target_id: 'test-id')
      expect(result).to include('test-id')
      expect(result).to include('skeleton-loader')
      expect(result).to include('data-target-id="test-id"')
      expect(result).to include('Mock Template Content')
    end

    it 'includes target_display_type when provided' do
      result = helper.skeleton_loader(target_id: 'test-id', target_display_type: 'block')
      expect(result).to include('data-target-display-type="block"')
    end

    it 'accepts a block for custom content' do
      result = helper.skeleton_loader(target_id: 'test-id') { 'Custom content' }
      expect(result).to include('Custom content')
    end
  end
end
