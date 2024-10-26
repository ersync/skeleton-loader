# spec/generators/skeleton_loader/reset_templates_generator_spec.rb
require 'spec_helper'
require 'generators/skeleton_loader/reset_templates_generator'
require 'fileutils'

RSpec.describe SkeletonLoader::Generators::ResetTemplatesGenerator, type: :generator do
  let(:destination_root) { File.expand_path("../../tmp", __dir__) }

  before(:each) do
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(File.join(destination_root, "app/views/skeleton_loader"))
  end

  after(:each) do
    FileUtils.rm_rf(destination_root)
  end

  it "overwrites existing templates with default ones" do
    modified_file_path = File.join(destination_root, "app/views/skeleton_loader/_card.html.erb")
    File.write(modified_file_path, "Modified content")

    generator = described_class.new([], [], destination_root: destination_root)
    generator.invoke_all

    expect(File.read(modified_file_path)).not_to eq("Modified content")

    expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_card.html.erb")), "Expected _card.html.erb to be created"
    expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_cast_skeleton.html.erb")), "Expected _cast_skeleton.html.erb to be created"
  end
end
