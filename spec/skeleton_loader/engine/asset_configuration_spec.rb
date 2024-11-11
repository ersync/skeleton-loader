# frozen_string_literal: true

RSpec.describe SkeletonLoader::Engine, ".asset_configuration" do
  let(:asset_paths) { [] }
  let(:precompile_array) { [] }
  let(:assets) do
    double("Assets").tap do |assets|
      allow(assets).to receive_messages(paths: asset_paths, precompile: precompile_array)
      allow(assets).to receive(:precompile=) { |array| precompile_array.concat(array) }
    end
  end
  let(:config) { double("Config", assets: assets) }
  let(:app) { double("Rails::Application", config: config) }

  before { find_initializer("skeleton_loader.assets").run(app) }

  it "includes JavaScript asset path" do
    js_path = Pathname.new(engine_root.join("app", "assets", "javascripts").to_s)
    expect(asset_paths).to include(js_path)
  end

  it "includes stylesheet asset path" do
    css_path = Pathname.new(engine_root.join("app", "assets", "stylesheets").to_s)
    expect(asset_paths).to include(css_path)
  end

  it "includes skeleton_loader.css in precompilation" do
    expect(precompile_array).to include("skeleton_loader.css")
  end

  it "includes skeleton_loader.js in precompilation" do
    expect(precompile_array).to include("skeleton_loader.js")
  end

  private

  def find_initializer(name)
    described_class.instance.initializers.find { |i| i.name == name }
  end

  def engine_root
    described_class.instance.root
  end
end
