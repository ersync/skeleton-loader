# frozen_string_literal: true

RSpec.describe SkeletonLoader::SkeletonElementGenerator do
  let(:content_id) { "test-content" }
  let(:template_finder) { class_double(SkeletonLoader::TemplatePathFinder).as_stubbed_const }
  let(:template_renderer) { class_double(SkeletonLoader::TemplateRenderer).as_stubbed_const }

  # Create a simple class to handle html_safe strings
  let(:html_safe_string) do
    Class.new(String) do
      def html_safe?
        true
      end

      def html_safe
        self
      end
    end
  end

  let(:helper_module) do
    safe_string_class = html_safe_string
    Module.new do
      define_singleton_method(:content_tag) do |tag, content, options|
        safe_string_class.new(
          "<#{tag} class='#{options[:class]}' data-content-id='#{options[:data][:content_id]}'>#{content}</#{tag}>"
        )
      end
    end
  end

  before do
    stub_const("ActionController::Base", Module.new { def self.helpers; end })
    allow(ActionController::Base).to receive(:helpers).and_return(helper_module)
  end

  describe ".generate" do
    context "with invalid input" do
      it "raises error when content_id is nil" do
        expect { described_class.generate(content_id: nil) }
          .to raise_error(SkeletonLoader::Error, "content_id is required")
      end

      it "raises error when content_id is empty" do
        expect { described_class.generate(content_id: "") }
          .to raise_error(SkeletonLoader::Error, "content_id is required")
      end

      it "raises error when block given with options" do
        expect do
          described_class.generate(content_id: content_id, options: { type: "card" }) { "content" }
        end.to raise_error(SkeletonLoader::Error, "Options cannot be used with a block")
      end
    end

    context "with block content" do
      subject(:generate_with_block) do
        described_class.generate(content_id: content_id) { "block content" }
      end

      it "wraps block content in loader div" do
        expect(generate_with_block).to include("block content")
      end

      it "marks content as html safe" do
        expect(generate_with_block).to be_html_safe
      end
    end

    context "with template content" do
      before do
        allow(template_finder).to receive(:find).with("card").and_return("path/to/template")
        allow(template_renderer).to receive(:render).and_return("template content")
      end

      it "finds template path" do
        described_class.generate(content_id: content_id, options: { type: "card" })
        expect(template_finder).to have_received(:find).with("card")
      end

      it "renders template with options" do
        options = { type: "card", width: 200 }
        described_class.generate(content_id: content_id, options: options)
        expect(template_renderer).to have_received(:render).with("path/to/template", options)
      end
    end

    context "with default template type" do
      before do
        allow(template_finder).to receive(:find).with("default").and_return("path/to/default")
        allow(template_renderer).to receive(:render).and_return("default content")
      end

      it "uses default type when not specified" do
        described_class.generate(content_id: content_id, options: {})
        expect(template_finder).to have_received(:find).with("default")
      end
    end

    context "with different contexts" do
      it "adds static class for view context" do
        result = described_class.generate(content_id: content_id) { "content" }
        expect(result).to include("skeleton-loader--static")
      end

      it "adds ajax class for controller context" do
        result = described_class.generate(
          content_id: content_id,
          context: :controller
        ) { "content" }
        expect(result).to include("skeleton-loader--ajax")
      end
    end

    context "with content wrapping" do
      it "includes content id in data attribute" do
        result = described_class.generate(content_id: content_id) { "content" }
        expect(result).to include("data-content-id='#{content_id}'")
      end

      it "wraps content in div tag" do
        result = described_class.generate(content_id: content_id) { "content" }
        expect(result).to match(%r{\A<div.*>.*</div>\z})
      end
    end
  end
end
