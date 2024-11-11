# frozen_string_literal: true

RSpec.describe SkeletonLoader::Engine, ".routes_configuration" do
  let(:mapper) { double("Mapper") }
  let(:routes) { double("ActionDispatch::Routing::RouteSet") }
  let(:app) { double("Rails::Application") }

  before do
    allow(app).to receive(:routes).and_return(routes)
    allow(routes).to receive(:prepend) do |&block|
      mapper.instance_eval(&block)
    end
  end

  it "mounts the engine at /skeleton_loader" do
    allow(mapper).to receive(:mount)
      .with(described_class, at: "/skeleton_loader", as: "skeleton_loader_engine")

    find_initializer("skeleton_loader.append_routes").run(app)

    expect(mapper).to have_received(:mount)
      .with(described_class, at: "/skeleton_loader", as: "skeleton_loader_engine")
  end

  private

  def find_initializer(name)
    described_class.instance.initializers.find { |i| i.name == name }
  end
end
