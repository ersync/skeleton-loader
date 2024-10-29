# frozen_string_literal: true

require "rails/generators"
require "generators/skeleton_loader/install_generator"
require "fileutils"

RSpec.describe SkeletonLoader::Generators::InstallGenerator, type: :generator do
  let(:destination_root) { File.expand_path("../../../../tmp", __dir__) }

  before do
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(destination_root)
  end

  after do
    FileUtils.rm_rf(destination_root)
  end

  describe "when invoking the generator" do
    let(:generator) { described_class.new([], [], destination_root: destination_root) }

    before { generator.invoke_all }

    it "creates the _card.html.erb template" do
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_card.html.erb")),
                      "Expected _card.html.erb template to be created"
    end

    it "creates the _cast_skeleton.html.erb template" do
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_cast_skeleton.html.erb")),
                      "Expected _cast_skeleton.html.erb template to be created"
    end

    it "creates the initializer in config/initializers" do
      expect(File).to exist(File.join(destination_root, "config/initializers/skeleton_loader.rb")),
                      "Expected initializer to be created in config/initializers"
    end
  end
end
