# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

RSpec.describe SkeletonLoader::SkeletonSanitizer do
  let(:config) { instance_double(SkeletonLoader::Configuration) }
  let(:additional_css_properties) { ["transform"] }
  let(:safe_list_sanitizer) { double("Rails::HTML4::SafeListSanitizer") }
  let(:sanitizer_class) { double("Rails::HTML4::SafeListSanitizer") }

  let(:default_css_properties) do
    %w[display grid grid-template-columns grid-template-rows gap width height padding padding-bottom padding-left
       padding-right padding-top margin margin-bottom margin-left margin-right margin-top flex flex-direction
       flex-shrink flex-grow align-items justify-content border-radius overflow animation background
       background-color].uniq
  end

  before do
    allow(SkeletonLoader).to receive(:configuration).and_return(config)
    allow(config).to receive(:additional_allowed_css_properties)
      .and_return(additional_css_properties)
    allow(sanitizer_class).to receive_messages(new: safe_list_sanitizer, allowed_tags: %w[p span],
                                               allowed_attributes: %w[id])
    allow(safe_list_sanitizer).to receive(:sanitize).and_return("sanitized content")
    stub_const("Rails::HTML4::SafeListSanitizer", sanitizer_class)
  end

  describe ".sanitize" do
    subject(:sanitize) { described_class.sanitize(content) }

    context "when sanitizing HTML with allowed tags" do
      let(:content) { "<div>Test</div>" }

      it "makes content html_safe" do
        expect(sanitize).to be_html_safe
      end
    end

    context "when sanitizing with custom CSS properties" do
      let(:content) { "<div style='display: grid'>Test</div>" }
      let(:expected_properties) { default_css_properties + additional_css_properties }

      it "calls sanitize on safe_list_sanitizer" do
        sanitize
        expect(safe_list_sanitizer).to have_received(:sanitize)
      end

      it "includes all expected CSS properties" do
        sanitize
        safe_list_sanitizer.sanitize do |_, options|
          actual_props = options[:css][:properties] - %w[# Layout Flexbox Visual Animations effects loading skeleton]
          expect(actual_props).to match_array(expected_properties)
        end
      end
    end

    context "when sanitizing with data attributes" do
      let(:content) { "<div data-test='value'>Test</div>" }

      it "calls sanitize on safe_list_sanitizer" do
        sanitize
        expect(safe_list_sanitizer).to have_received(:sanitize)
      end

      it "allows data-* attributes" do
        sanitize
        safe_list_sanitizer.sanitize do |_, options|
          expect(options[:attributes]).to include("data-*")
        end
      end
    end

    context "when sanitizing with aria attributes" do
      let(:content) { "<div aria-label='test'>Test</div>" }

      it "calls sanitize on safe_list_sanitizer" do
        sanitize
        expect(safe_list_sanitizer).to have_received(:sanitize)
      end

      it "allows aria-* attributes" do
        sanitize
        safe_list_sanitizer.sanitize do |_, options|
          expect(options[:attributes]).to include("aria-*")
        end
      end
    end

    context "when sanitizing with custom tags" do
      let(:content) { "<div>Test</div>" }

      it "calls sanitize on safe_list_sanitizer" do
        sanitize
        expect(safe_list_sanitizer).to have_received(:sanitize)
      end

      it "allows div and style tags" do
        sanitize
        safe_list_sanitizer.sanitize do |_, options|
          expect(options[:tags]).to include("div", "style")
        end
      end
    end

    context "when Rails::HTML4::SafeListSanitizer is not available" do
      let(:content) { "<div>Test</div>" }
      # rubocop:disable RSpec/VerifiedDoubleReference
      let(:html_sanitizer_class) { class_double("Rails::HTML::SafeListSanitizer") }
      # rubocop:enable RSpec/VerifiedDoubleReference

      before do
        hide_const("Rails::HTML4::SafeListSanitizer")
        stub_const("Rails::HTML::SafeListSanitizer", html_sanitizer_class)
        allow(html_sanitizer_class).to receive_messages(new: safe_list_sanitizer, allowed_tags: %w[p span],
                                                        allowed_attributes: %w[id])
      end

      it "uses Rails::HTML::SafeListSanitizer" do
        sanitize
        expect(html_sanitizer_class).to have_received(:new)
      end
    end
  end
end

# rubocop:enable RSpec/MultipleMemoizedHelpers
