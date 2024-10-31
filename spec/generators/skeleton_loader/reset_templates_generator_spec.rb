# frozen_string_literal: true

require "generators/skeleton_loader/reset_templates_generator"
require "fileutils"

RSpec.describe SkeletonLoader::Generators::ResetTemplatesGenerator, type: :generator do
  let(:destination_root) { File.expand_path("../../tmp", __dir__) }
  let(:templates) { %w[_card _comment _gallery _paragraph _product] }
  let(:source_dir) { File.expand_path("templates", __dir__) }

  before do
    FileUtils.rm_rf(destination_root)
    FileUtils.mkdir_p(File.join(destination_root, "app/views/skeleton_loader"))
    FileUtils.mkdir_p(source_dir)

    templates.each do |template|
      source_template_path = File.join(source_dir, "#{template}.html.erb")
      File.write(source_template_path, "<!-- Default content for #{template} -->")
    end
    allow(described_class).to receive(:source_root).and_return(source_dir)
  end

  after { FileUtils.rm_rf(destination_root) }

  describe "when invoking the generator" do
    let(:generator) { described_class.new([], [], destination_root: destination_root) }

    before do
      templates.each do |template|
        modified_path = File.join(destination_root, "app/views/skeleton_loader/#{template}.html.erb")
        File.write(modified_path, "Modified content for #{template}")
      end
    end

    it "overwrites existing templates with default ones" do
      generator.invoke_all

      templates.each do |template|
        template_path = File.join(destination_root, "app/views/skeleton_loader/#{template}.html.erb")
        expect(File.read(template_path)).to eq("<!-- Default content for #{template} -->")
      end
    end
  end
end
