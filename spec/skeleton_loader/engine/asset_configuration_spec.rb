# frozen_string_literal: true

RSpec.describe SkeletonLoader::Engine, ".asset_configuration" do
  let(:asset_paths) { [] }
  let(:precompile_array) { [] }
  let(:assets) do
    double("Assets").tap do |assets|
      allow(assets).to receive_messages(paths: asset_paths, precompile: precompile_array)
      allow(assets).to receive(:precompile=) { |array| precompile_array.concat(array) }
      allow(assets.paths).to receive(:reject!)
    end
  end
  let(:config) { double("Config", assets: assets) }
  let(:app) { double("Rails::Application", config: config) }

  context "when using standard asset pipeline" do
    before do
      hide_const("Webpacker")
      hide_const("Shakapacker")
      hide_const("Importmap::Engine")
      find_initializer("skeleton_loader.assets").run(app)
    end

    it "includes stylesheet asset path" do
      css_path = Pathname.new(engine_root.join("app/assets/stylesheets").to_s)
      expect(asset_paths).to include(css_path)
    end

    it "includes javascript asset path" do
      js_path = Pathname.new(engine_root.join("app/assets/javascripts").to_s)
      expect(asset_paths).to include(js_path)
    end

    it "precompiles CSS file" do
      expect(precompile_array).to include("skeleton_loader.css")
    end

    it "precompiles JS file" do
      expect(precompile_array).to include("skeleton_loader.js")
    end
  end

  context "when using Webpacker/Shakapacker" do
    before do
      stub_const("Webpacker", Class.new)
      find_initializer("skeleton_loader.assets").run(app)
    end

    it "includes only stylesheet asset path" do
      css_path = Pathname.new(engine_root.join("app/assets/stylesheets").to_s)
      expect(asset_paths).to include(css_path)
    end

    it "precompiles only CSS file" do
      expect(precompile_array).to include("skeleton_loader.css")
    end

    it "does not include javascript asset path" do
      js_path = Pathname.new(engine_root.join("app/assets/javascripts").to_s)
      expect(asset_paths).not_to include(js_path)
    end
  end

  context "when using Importmap" do
    before do
      stub_const("Importmap::Engine", Class.new)
      find_initializer("skeleton_loader.assets").run(app)
    end

    it "includes stylesheet asset path" do
      css_path = Pathname.new(engine_root.join("app/assets/stylesheets").to_s)
      expect(asset_paths).to include(css_path)
    end

    it "includes dist path" do
      dist_path = Pathname.new(engine_root.join("dist").to_s)
      expect(asset_paths).to include(dist_path)
    end

    it "removes original javascript asset path" do
      engine_root.join("app/assets/javascripts").to_s
      expect(asset_paths).to have_received(:reject!)
    end

    it "precompiles CSS file" do
      expect(precompile_array).to include("skeleton_loader.css")
    end

    it "precompiles JS file" do
      expect(precompile_array).to include("skeleton_loader.js")
    end
  end

  private

  def find_initializer(name)
    described_class.instance.initializers.find { |i| i.name == name }
  end

  def engine_root
    described_class.instance.root
  end
end
