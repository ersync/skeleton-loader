require 'spec_helper'
require 'generators/skeleton_loader/install_generator'
require 'fileutils'

RSpec.describe SkeletonLoader::Generators::InstallGenerator, type: :generator do
  let(:destination_root) { File.expand_path("../../tmp", __dir__) }

  before(:each) do
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(destination_root)
  end

  after(:each) do
    FileUtils.rm_rf(destination_root)
  end

  it "creates the skeleton loader templates and initializer" do
    generator = described_class.new([], [], destination_root: destination_root)
    generator.invoke_all

    expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_card.html.erb")), "Expected _card.html.erb template to be created"
    expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_cast_skeleton.html.erb")), "Expected _card.html.erb template to be created"

    expect(File).to exist(File.join(destination_root, "config/initializers/skeleton_loader.rb")), "Expected initializer to be created in config/initializers"
  end
end
