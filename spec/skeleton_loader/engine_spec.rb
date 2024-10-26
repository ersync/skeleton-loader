require 'spec_helper'
require 'skeleton_loader/view_helpers'
require 'skeleton_loader/engine'

RSpec.describe SkeletonLoader::Engine do
  let(:asset_paths) { [] }
  let(:precompile_array) { [] }

  let(:assets) do
    double('Assets').tap do |assets|
      allow(assets).to receive(:paths).and_return(asset_paths)
      allow(assets).to receive(:precompile).and_return(precompile_array)
      allow(assets).to receive(:precompile=) { |array| precompile_array.concat(array) }
    end
  end

  let(:app) do
    double("Rails app", config: double("Config", assets: assets))
  end

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
    before do
      allow(app.config.assets.precompile).to receive(:<<).with("skeleton_loader.css").and_return(true)
      allow(app.config.assets.precompile).to receive(:<<).with("skeleton_loader.js").and_return(true)

      initializer = engine.initializers.find { |i| i.name == "skeleton_loader.assets" }
      initializer.run(app)
    end

    it "adds JavaScript and stylesheet asset paths" do
      expected_paths = [
        engine.root.join("app", "assets", "javascripts").to_s,
        engine.root.join("app", "assets", "stylesheets").to_s
      ]
      actual_paths = app.config.assets.paths.map(&:to_s)

      expect(actual_paths).to include(*expected_paths)
    end

    it "precompiles specified assets" do
      expect(app.config.assets.precompile).to include("skeleton_loader.css", "skeleton_loader.js")
    end
  end

  describe "view helper configuration" do
    let(:view_context) { Class.new }

    before do
      allow(ActiveSupport).to receive(:on_load).with(:action_view) do |&block|
        view_context.class_eval(&block)
      end
      initializer = engine.initializers.find { |i| i.name == "skeleton_loader.view_helpers" }
      initializer.run(app)
    end

    it "includes SkeletonLoader::ViewHelpers in ActionView" do
      expect(view_context.included_modules).to include(SkeletonLoader::ViewHelpers)
    end
  end
end