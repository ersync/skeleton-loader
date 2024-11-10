# frozen_string_literal: true

module MockRails
  class HTML
    class SafeListSanitizer
      def self.allowed_tags
        %w[div p]
      end

      def self.allowed_attributes
        %w[style class]
      end

      def sanitize(content, options = {})
        @allowed_tags = options[:tags] || []
        @allowed_attributes = options[:attributes] || []
        @allowed_css = options.dig(:css, :properties) || []

        doc = content.dup
        remove_disallowed_tags(doc)
        remove_disallowed_attributes(doc)
        process_style_attributes(doc)
        process_data_and_aria_attributes(doc)
        doc
      end

      private

      def remove_disallowed_tags(doc)
        %w[script onclick].each do |bad_tag|
          doc.gsub!(%r{<#{bad_tag}.*?>.*?</#{bad_tag}>}, "")
        end
      end

      def remove_disallowed_attributes(doc)
        doc.gsub!(/\s(onclick|onerror|onload)="[^"]*"/, "")
      end

      def process_style_attributes(doc)
        return unless doc.include?('style="')

        doc.gsub!(/style="([^"]*)"/) do |_style_attr|
          style_content = Regexp.last_match(1)
          clean_props = clean_css_properties(style_content)
          "style=\"#{clean_props}\""
        end
      end

      def clean_css_properties(style_content)
        clean_props = style_content.split(";").map(&:strip).select do |prop|
          property_name = prop.split(":").first&.strip
          @allowed_css.include?(property_name)
        end.join("; ")
        clean_props += ";" unless clean_props.empty? || clean_props.end_with?(";")
        clean_props
      end

      def process_data_and_aria_attributes(doc)
        return unless @allowed_attributes.include?("data-*") || @allowed_attributes.include?("aria-*")

        doc.gsub!(/\s(data-\w+|aria-\w+)="([^"]*)"/) { |attr| attr }
      end
    end
  end

  HTML4 = HTML
end
RSpec.describe SkeletonLoader::SkeletonSanitizer do
  describe ".sanitize" do
    before do
      stub_const("Rails", MockRails)
      allow(SkeletonLoader).to receive(:configuration).and_return(config)
      allow(config).to receive(:additional_allowed_css_properties).and_return(["custom-property"])
      allow(SkeletonLoader).to receive(:configuration).and_return(config)
      allow(config).to receive(:additional_allowed_css_properties).and_return(["custom-property"])
    end

    let(:config) { instance_double(SkeletonLoader::Configuration) }

    context "when handling HTML tags" do
      it "allows p tags" do
        input = "<p>Hello</p>"
        expect(described_class.sanitize(input)).to include("<p>Hello</p>")
      end

      it "allows div tags" do
        input = "<div>Content</div>"
        expect(described_class.sanitize(input)).to include("<div>Content</div>")
      end

      it "removes script tags" do
        input = '<script>alert("xss")</script>'
        expect(described_class.sanitize(input)).not_to include("<script>")
      end
    end

    context "when handling attributes" do
      it "allows style attributes" do
        input = '<div style="display: flex;">Content</div>'
        expect(described_class.sanitize(input)).to include('style="display: flex;"')
      end

      it "allows data-* attributes" do
        input = '<div data-test="value">Content</div>'
        expect(described_class.sanitize(input)).to include('data-test="value"')
      end

      it "allows aria-* attributes" do
        input = '<div aria-label="description">Content</div>'
        expect(described_class.sanitize(input)).to include('aria-label="description"')
      end

      it "removes onclick attributes" do
        input = '<div onclick="alert()">Content</div>'
        expect(described_class.sanitize(input)).not_to include("onclick")
      end
    end

    context "when handling CSS properties" do
      it "allows display property" do
        input = '<div style="display: grid;">Content</div>'
        expect(described_class.sanitize(input)).to include('style="display: grid;"')
      end

      it "allows width property" do
        input = '<div style="width: 100%;">Content</div>'
        expect(described_class.sanitize(input)).to include('style="width: 100%;"')
      end

      it "allows padding property" do
        input = '<div style="padding: 10px;">Content</div>'
        expect(described_class.sanitize(input)).to include('style="padding: 10px;"')
      end

      it "allows custom properties from configuration" do
        input = '<div style="custom-property: value;">Content</div>'
        expect(described_class.sanitize(input)).to include('style="custom-property: value;"')
      end

      it "removes disallowed CSS properties" do
        input = '<div style="behavior: url(script.htc);">Content</div>'
        expect(described_class.sanitize(input)).to eq('<div style="">Content</div>')
      end

      it "keeps allowed properties when mixed with disallowed ones" do
        input = '<div style="display: grid; bad-prop: value;">Content</div>'
        expect(described_class.sanitize(input)).to eq('<div style="display: grid;">Content</div>')
      end
    end

    it "marks output as html_safe" do
      result = described_class.sanitize("<div>Content</div>")
      expect(result).to be_html_safe
    end
  end
end
