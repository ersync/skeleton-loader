require 'spec_helper'

RSpec.describe SkeletonLoader::TemplateRenderer do
  let(:template_path) { 'spec/fixtures/test_template.html.erb' }
  let(:options) { { width: '200px' } }

  describe '#render' do
    before do
      FileUtils.mkdir_p('spec/fixtures')
      File.write(template_path, '<div style="width: <%= @width %>">Test</div>')
    end

    after do
      FileUtils.rm_rf('spec/fixtures')
    end

    it 'renders template with configuration options' do
      renderer = described_class.new(template_path, options)
      expect(renderer.render).to include('width: 200px')
    end
  end
end