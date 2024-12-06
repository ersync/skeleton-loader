# frozen_string_literal: true

require "rails/generators"
require "generators/skeleton_loader/add_templates_generator"
require "fileutils"

RSpec.describe SkeletonLoader::Generators::AddTemplatesGenerator, type: :generator do
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

    it "creates the _comment.html.erb template" do
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_comment.html.erb")),
                      "Expected _comment.html.erb template to be created"
    end

    it "creates the _gallery.html.erb template" do
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_gallery.html.erb")),
                      "Expected _gallery.html.erb template to be created"
    end

    it "creates the _paragraph.html.erb template" do
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_paragraph.html.erb")),
                      "Expected _paragraph.html.erb template to be created"
    end

    it "creates the _product.html.erb template" do
      expect(File).to exist(File.join(destination_root, "app/views/skeleton_loader/_product.html.erb")),
                      "Expected _product.html.erb template to be created"
    end
  end
end
