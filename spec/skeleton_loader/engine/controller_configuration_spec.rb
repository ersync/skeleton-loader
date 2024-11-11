# frozen_string_literal: true

RSpec.describe SkeletonLoader::Engine, ".controller_configuration" do
  let(:controller_paths) { [] }
  let(:paths) do
    double("Paths").tap do |paths|
      allow(paths).to receive(:[]).with("app/controllers").and_return(controller_paths)
      allow(paths).to receive(:<<) { |path| controller_paths << path }
    end
  end

  before do
    allow(described_class.instance.config).to receive(:paths).and_return(paths)
    find_initializer("skeleton_loader.append_migrations").run
  end

  it "adds the engine's controllers path" do
    expect(controller_paths.first).to end_with("app/controllers")
  end

  private

  def find_initializer(name)
    described_class.instance.initializers.find { |i| i.name == name }
  end
end
