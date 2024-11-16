# frozen_string_literal: true

RSpec.describe SkeletonLoader::TemplateRenderer do
  let(:template_path) { "spec/fixtures/test_template.html.erb" }
  let(:options) { { type: :card, width: 400 } }
  let(:configuration) do
    instance_double(
      SkeletonLoader::Configuration,
      base_options: { scale: 1.0, animation_type: "sl-gradient" },
      template_defaults_for: { width: 200, count: 3, per_row: 3 }
    )
  end

  before do
    allow(SkeletonLoader).to receive(:configuration).and_return(configuration)
    FileUtils.mkdir_p("spec/fixtures")
  end

  after do
    FileUtils.rm_rf("spec/fixtures")
  end

  describe ".render" do
    subject(:render_template) { described_class.render(template_path, options) }

    let(:instance) { instance_double(described_class) }

    before do
      allow(described_class).to receive(:new)
        .with(template_path, options)
        .and_return(instance)
      allow(instance).to receive(:render)
    end

    it "creates new instance with correct parameters" do
      render_template
      expect(described_class).to have_received(:new).with(template_path, options)
    end
  end

  describe "#initialize" do
    subject(:renderer) { described_class.new(template_path, options) }

    it "sets template path" do
      expect(renderer.instance_variable_get(:@template_path)).to eq(template_path)
    end

    it "merges configuration options" do
      expect(renderer.instance_variable_get(:@scale)).to eq(1.0)
    end
  end

  describe "#render" do
    subject(:renderer) { described_class.new(template_path, options) }

    context "with valid template" do
      before do
        File.write(
          template_path,
          '<div data-scale="<%= @scale %>"><%= @width %></div>'
        )
      end

      it "renders template with correct values" do
        expect(renderer.render).to include('data-scale="1.0"')
      end
    end

    context "with invalid template" do
      before do
        File.write(template_path, "<%= undefined_variable %>")
      end

      it "raises error with template path" do
        expect { renderer.render }
          .to raise_error(/Error rendering template at #{template_path}/)
      end
    end
  end

  describe "private #merge_options" do
    subject(:renderer) { described_class.new(template_path, options) }

    before do
      allow(configuration).to receive(:template_defaults_for)
        .with(:card)
        .and_return(width: 200, count: 3, per_row: 3)
    end

    it "combines base options with template defaults" do
      merged_options = renderer.send(:merge_options, options)
      expect(merged_options[:width]).to eq(400)
    end

    it "includes configuration base options" do
      merged_options = renderer.send(:merge_options, options)
      expect(merged_options[:scale]).to eq(1.0)
    end
  end
end
