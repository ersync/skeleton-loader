# frozen_string_literal: true

RSpec.describe SkeletonLoader::TemplateRenderer do
  let(:template_path) { "spec/fixtures/test_template.html.erb" }
  let(:options) { { width: "200px" } }
  let(:config) { { height: "100px" } }

  before do
    allow(SkeletonLoader).to receive(:configuration)
      .and_return(double(to_h: config))
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

    it "delegates rendering to a new instance" do
      render_template
      expect(instance).to have_received(:render)
    end
  end

  describe "#render" do
    subject(:renderer) { described_class.new(template_path, options) }

    before do
      FileUtils.mkdir_p("spec/fixtures")
    end

    after do
      FileUtils.rm_rf("spec/fixtures")
    end

    context "with valid template" do
      before do
        File.write(
          template_path,
          '<div style="width: <%= @width %>; height: <%= @height %>">Test</div>'
        )
      end

      it "includes configured width" do
        expect(renderer.render).to include("width: 200px")
      end

      it "includes configured height" do
        expect(renderer.render).to include("height: 100px")
      end
    end

    context "with invalid template" do
      before do
        File.write(template_path, "<%= undefined_variable %>")
      end

      it "raises error with template path" do
        error_message = /An error occurred while rendering the template located at #{template_path}/
        expect { renderer.render }.to raise_error(RuntimeError, error_message)
      end
    end
  end
end
