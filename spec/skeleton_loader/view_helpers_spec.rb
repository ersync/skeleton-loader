# frozen_string_literal: true

RSpec.describe SkeletonLoader::ViewHelpers, type: :helper do
  let(:view) { ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil) }
  let(:logger) { instance_spy(Logger) }

  before do
    view.extend(described_class)
    allow(Rails).to receive(:logger).and_return(logger)
  end

  describe "#skeleton_loader" do
    context "when a block is provided" do
      let(:content_id) { "content_123" }
      let(:options) { { class: "custom-class", data: { test: "value" } } }
      let(:block_content) { "Loading content..." }

      before do
        allow(SkeletonLoader::SkeletonElementGenerator).to receive(:generate)
          .and_return("
#{block_content}
")
      end

      it "calls SkeletonElementGenerator with content_id, options, and block" do
        block = proc { block_content }

        view.skeleton_loader(content_id: content_id, **options, &block)

        expect(SkeletonLoader::SkeletonElementGenerator).to have_received(:generate)
          .with(content_id: content_id, options: options, &block)
      end
    end

    context "when no block is provided" do
      let(:content_id) { "content_123" }
      let(:options) { { class: "custom-class" } }

      before do
        allow(SkeletonLoader::SkeletonElementGenerator).to receive(:generate)
          .and_return("
")
      end

      it "calls SkeletonElementGenerator with content_id and options" do
        view.skeleton_loader(content_id: content_id, **options)

        expect(SkeletonLoader::SkeletonElementGenerator).to have_received(:generate)
          .with(content_id: content_id, options: options)
      end
    end

    context "when an error occurs" do
      let(:error_message) { "Test error" }

      before do
        allow(SkeletonLoader::SkeletonElementGenerator).to receive(:generate)
          .and_raise(StandardError.new(error_message))
      end

      def call_with_error_handling
        view.skeleton_loader(content_id: "content_123")
      rescue StandardError
        nil
      end

      it "doesn't raise the error" do
        expect { call_with_error_handling }.not_to raise_error
      end

      it "logs the error message" do
        call_with_error_handling
        expect(logger).to have_received(:error)
          .with("Error in skeleton_loader helper: #{error_message}")
      end
    end

    context "with only content_id provided" do
      before do
        allow(SkeletonLoader::SkeletonElementGenerator).to receive(:generate)
          .and_return("
")
      end

      it "does not raise an error" do
        expect { view.skeleton_loader(content_id: "content_123") }.not_to raise_error
      end
    end
  end
end
