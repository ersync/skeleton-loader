# frozen_string_literal: true

require "spec_helper"

RSpec.describe SkeletonLoader::SkeletonElementGenerator do
  let(:content_id) { "test-content" }
  let(:sanitizer) { class_double(SkeletonLoader::SkeletonSanitizer).as_stubbed_const }
  let(:template_finder) { class_double(SkeletonLoader::TemplatePathFinder).as_stubbed_const }
  let(:template_renderer) { class_double(SkeletonLoader::TemplateRenderer).as_stubbed_const }
  let(:helper_module) do
    Module.new do
      def self.content_tag(tag, content, options)
        "<#{tag} class='#{options[:class]}' data-content-id='#{options[:data][:content_id]}'>#{content}</#{tag}>"
      end
    end
  end

  before do
    stub_const("ActionController::Base", Module.new { def self.helpers; end })
    allow(ActionController::Base).to receive(:helpers).and_return(helper_module)
    allow(sanitizer).to receive(:sanitize) { |content| content }
  end

  describe ".generate basic functionality" do
    it "raises an error when content_id is missing" do
      expect { described_class.generate(content_id: nil) }
        .to raise_error(SkeletonLoader::Error, "content_id is required")
    end

    it "sanitizes the block content" do
      described_class.generate(content_id: content_id) { "block content" }
      expect(sanitizer).to have_received(:sanitize).with("block content")
    end

    it "raises error when block is given with options" do
      expect do
        described_class.generate(content_id: content_id, options: { type: "card" }) { "content" }
      end.to raise_error(SkeletonLoader::Error, "Options cannot be used with a block")
    end

    it "uses static class for view context" do
      result = described_class.generate(content_id: content_id) { "content" }
      expect(result).to include("skeleton-loader--static")
    end

    it "uses ajax class for controller context" do
      result = described_class.generate(content_id: content_id, context: :controller) { "content" }
      expect(result).to include("skeleton-loader--ajax")
    end
  end

  describe ".generate template handling" do
    before do
      allow(template_finder).to receive(:find).and_return("path/to/template")
      allow(template_renderer).to receive(:render).and_return("rendered content")
    end

    it "finds the correct template path with card type" do
      described_class.generate(
        content_id: content_id,
        options: { type: "card", extra: "value" }
      )
      expect(template_finder).to have_received(:find).with("card")
    end

    it "renders the template with all options" do
      options = { type: "card", extra: "value" }
      described_class.generate(content_id: content_id, options: options)
      expect(template_renderer)
        .to have_received(:render)
        .with("path/to/template", options)
    end

    it "uses default type when not specified" do
      described_class.generate(
        content_id: content_id,
        options: { extra: "value" }
      )
      expect(template_finder).to have_received(:find).with("default")
    end
  end
end
