# frozen_string_literal: true

require "generators/skeleton_loader/reset_templates_generator"
require "fileutils"

RSpec.describe SkeletonLoader::Generators::ResetTemplatesGenerator, type: :generator do
  let(:destination_root) { File.expand_path("../../tmp", __dir__) }

  before do
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(File.join(destination_root, "app/views/skeleton_loader"))
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  describe "when invoking the generator" do
    let(:generator) { described_class.new([], [], destination_root: destination_root) }

    before do
      # Create a modified file to be overwritten
      modified_file_path = File.join(destination_root, "app/views/skeleton_loader/_card.html.erb")
      File.write(modified_file_path, "Modified content")
    end

    it "overwrites existing templates with default ones" do
      generator.invoke_all

      expect(File.read(File.join(destination_root,
                                 "app/views/skeleton_loader/_card.html.erb"))).not_to eq("Modified content")
    end

    it "creates the _card.html.erb template" do
      generator.invoke_all
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_card.html.erb")),
                      "Expected _card.html.erb to be created"
    end

    it "creates the _cast_skeleton.html.erb template" do
      generator.invoke_all
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_cast_skeleton.html.erb")),
                      "Expected _cast_skeleton.html.erb to be created"
    end
  end
end
