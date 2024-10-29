# frozen_string_literal: true

# rubocop:disable RSpec/MultipleMemoizedHelpers

require "skeleton_loader/view_helpers"
require "skeleton_loader/engine"
require "pathname" # Ensure you have this line to use Pathname

RSpec.describe SkeletonLoader::Engine do
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
  let(:engine) { described_class.instance }

  describe "initialization" do
    it "inherits from Rails::Engine" do
      expect(described_class.ancestors).to include(Rails::Engine)
    end

    it "isolates the SkeletonLoader namespace" do
      expect(engine.class.isolated?).to be true
    end
  end

  describe "asset configuration" do
    let(:initializer) { engine.initializers.find { |i| i.name == "skeleton_loader.assets" } }

    before { initializer.run(app) }

    context "when adding asset paths" do
      it "includes JavaScript asset path" do
        js_path = Pathname.new(engine.root.join("app", "assets", "javascripts").to_s)
        expect(asset_paths).to include(js_path)
      end

      it "includes stylesheet asset path" do
        css_path = Pathname.new(engine.root.join("app", "assets", "stylesheets").to_s)
        expect(asset_paths).to include(css_path)
      end
    end

    context "when precompiling assets" do
      it "includes skeleton_loader.css in precompilation" do
        expect(precompile_array).to include("skeleton_loader.css")
      end

      it "includes skeleton_loader.js in precompilation" do
        expect(precompile_array).to include("skeleton_loader.js")
      end
    end
  end

  describe "view helper configuration" do
    let(:view_context) { Class.new }
    let(:initializer) { engine.initializers.find { |i| i.name == "skeleton_loader.view_helpers" } }

    before do
      allow(ActiveSupport).to receive(:on_load).with(:action_view) do |&block|
        view_context.class_eval(&block)
      end
      initializer.run(app)
    end

    it "includes SkeletonLoader::ViewHelpers in ActionView" do
      expect(view_context.included_modules).to include(SkeletonLoader::ViewHelpers)
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
