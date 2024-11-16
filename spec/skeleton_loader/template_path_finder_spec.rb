# frozen_string_literal: true

RSpec.describe SkeletonLoader::TemplatePathFinder do
  describe ".find" do
    before do
      allow(Rails.root).to receive(:join)
        .with("app/views/skeleton_loader")
        .and_return("/rails/root/app/views/skeleton_loader")
    end

    context "when the template is found" do
      it "returns the full path of the template" do
        allow(File).to receive(:exist?)
          .with("/rails/root/app/views/skeleton_loader/_non_existent.html.erb")
          .and_return(true)

        expect(described_class.find("non_existent"))
          .to eq("/rails/root/app/views/skeleton_loader/_non_existent.html.erb")
      end
    end

    context "when the template is not found" do
      it "raises an error" do
        allow(File).to receive(:exist?)
          .with("/rails/root/app/views/skeleton_loader/_non_existent.html.erb")
          .and_return(false)

        expect { described_class.find("non_existent") }
          .to raise_error(/Template.*not found/)
      end
    end
  end
end
