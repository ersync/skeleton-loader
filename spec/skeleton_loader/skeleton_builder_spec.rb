# frozen_string_literal: true

RSpec.describe SkeletonLoader::SkeletonBuilder do
  let(:type) { "test-type" }
  let(:content_id) { "test-content" }
  let(:options) { { animation: "fade", border_color: "blue" } }
  let(:block_content) { "<div>Actual content here</div>".html_safe }

  describe "#generate" do
    subject(:generated_content) do
      described_class.new(type: type, content_id: content_id,
                          options: options, block: block).generate
    end

    context "when content_id is provided" do
      let(:block) { nil }

      before do
        allow(SkeletonLoader::TemplatePathFinder).to receive(:find).and_return("/path/to/template")
        allow(SkeletonLoader::TemplateRenderer).to receive(:render).and_return("Rendered skeleton content")
      end

      it "renders template content when no block is provided" do
        expect(generated_content).to include("Rendered skeleton content")
      end

      it "includes skeleton-loader class" do
        expect(generated_content).to include('class="skeleton-loader"')
      end

      it "includes correct content-id data attribute" do
        expect(generated_content).to include('data-content-id="test-content"')
      end
    end

    context "when content_id is missing" do
      let(:content_id) { nil }
      let(:block) { nil }

      it "raises an error" do
        expect { generated_content }.to raise_error(SkeletonLoader::Error, "content_id is required")
      end
    end

    context "when a block is provided" do
      let(:block) { proc { block_content } }

      it "includes the block content" do
        expect(generated_content).to include(block_content)
      end
    end
  end

  describe "#wrap_content" do
    subject(:wrapped_content) { builder.send(:wrap_content, "Test content") }

    let(:builder) { described_class.new(type: type, content_id: content_id, options: options) }
    let(:type) { "test-type" }
    let(:content_id) { "test-content" }
    let(:options) { { animation: "fade", border_color: "blue" } }

    it "includes skeleton-loader class" do
      expect(wrapped_content).to include('class="skeleton-loader"')
    end

    it "includes hidden display style" do
      expect(wrapped_content).to include('style="display:none;"')
    end

    it "includes correct content-id data attribute" do
      expect(wrapped_content).to include('data-content-id="test-content"')
    end
  end
end
