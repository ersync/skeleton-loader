require "spec_helper"

RSpec.describe SkeletonLoader::SkeletonContentGenerator do
  describe ".generate" do
    context "with block" do
      it "returns the block" do
        block = -> { "Custom content" }
        result = described_class.generate(&block)
        expect(result).to eq(block)
      end
    end

    context "with type" do
      let(:template_path) { "path/to/template.erb" }

      before do
        allow(SkeletonLoader::TemplatePathFinder).to receive(:find).and_return(template_path)
        allow(SkeletonLoader::TemplateRenderer).to receive(:render).and_return("Rendered content")
      end

      it "finds and renders template" do
        result = described_class.generate(type: "card")
        expect(SkeletonLoader::TemplatePathFinder).to have_received(:find).with("card")
        expect(SkeletonLoader::TemplateRenderer).to have_received(:render)
      end
    end

    context "without block or type" do
      it "returns default loading text" do
        result = described_class.generate
        expect(result).to eq("Loading...")
      end
    end
  end
end