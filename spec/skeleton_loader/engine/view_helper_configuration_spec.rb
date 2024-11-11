# frozen_string_literal: true

RSpec.describe SkeletonLoader::Engine, ".view helper_configuration" do
  let(:view_context) { Class.new }
  let(:config) { double("Config") }
  let(:app) { double("Rails::Application", config: config) }

  before do
    allow(ActiveSupport).to receive(:on_load).with(:action_view) do |&block|
      view_context.class_eval(&block)
    end
    find_initializer("skeleton_loader.view_helpers").run(app)
  end

  it "includes SkeletonLoader::ViewHelpers in ActionView" do
    expect(view_context.included_modules).to include(SkeletonLoader::ViewHelpers)
  end

  private

  def find_initializer(name)
    described_class.instance.initializers.find { |i| i.name == name }
  end
end
