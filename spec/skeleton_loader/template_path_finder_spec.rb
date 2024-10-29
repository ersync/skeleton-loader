# frozen_string_literal: true

RSpec.describe SkeletonLoader::TemplatePathFinder do
  describe ".find" do
    it "searches configured paths for template" do
      allow(Rails.root).to receive(:join)
        .with("app/views/skeleton_loader")
        .and_return("/rails/root/app/views/skeleton_loader")

      expect { described_class.find("non_existent") }
        .to raise_error(/Template.*not found/)
    end
  end
end
