require 'spec_helper'

RSpec.describe SkeletonLoader::TemplatePathFinder do
  describe '.find' do
    it 'searches configured paths for template' do
      allow(Rails).to receive_message_chain(:root, :join)
                        .and_return('/rails/root/app/views/skeleton_loader')

      expect { SkeletonLoader::TemplatePathFinder.find('non_existent') }
        .to raise_error(/Template.*not found/)
    end
  end
end