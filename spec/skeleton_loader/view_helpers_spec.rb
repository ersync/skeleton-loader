# frozen_string_literal: true

module SkeletonLoader
  RSpec.describe ViewHelpers, type: :helper do
    let(:view) { ActionView::Base.new(ActionView::LookupContext.new([]), {}, nil) }
    let(:logger) { instance_spy(Logger) }

    before do
      view.extend(described_class)
      allow(Rails).to receive(:logger).and_return(logger)
    end

    shared_examples "generated content with options" do |content_id, options, block_content|
      it "includes block content in the output" do
        allow(SkeletonElementGenerator).to receive(:generate)
          .and_return("<div>#{block_content}</div>")

        generated_content = view.skeleton_loader(content_id: content_id, **options) { block_content }
        expect(generated_content).to include(block_content)
      end
    end

    describe "#skeleton_loader" do
      context "when a block is provided" do
        let(:content_id) { "content_123" }
        let(:options) { { class: "custom-class", data: { test: "value" } } }
        let(:block_content) { "Loading content..." }

        before do
          allow(SkeletonElementGenerator).to receive(:generate)
            .and_return("<div>#{block_content}</div>")
        end

        it "calls SkeletonElementGenerator with block content" do
          view.skeleton_loader(content_id: content_id, **options) { block_content }

          expect(SkeletonElementGenerator).to have_received(:generate)
            .with(content_id: content_id)
        end

        include_examples "generated content with options", "content_123",
                         { class: "custom-class", data: { test: "value" } }, "Loading content..."
      end

      context "when no block is provided" do
        let(:generated_html) { "<div class='skeleton-loader' data-content-id='content_123'></div>" }

        before do
          allow(SkeletonElementGenerator).to receive(:generate).and_return(generated_html)
        end

        it "calls SkeletonElementGenerator without block content" do
          options = { class: "custom-class" }
          view.skeleton_loader(content_id: "content_123", **options)

          expect(SkeletonElementGenerator).to have_received(:generate)
            .with(content_id: "content_123", options: options)
        end
      end

      context "when an error occurs" do
        before do
          allow(SkeletonElementGenerator).to receive(:generate)
            .and_raise(StandardError.new("Test error"))
        end

        it "logs the error message" do
          begin
            view.skeleton_loader(content_id: "content_123")
          rescue StandardError
            # Expected error
          end
          expect(logger).to have_received(:error).with("Error in skeleton_loader helper: Test error")
        end

        it "re-raises the error" do
          expect do
            view.skeleton_loader(content_id: "content_123")
          end.to raise_error(StandardError)
        end
      end

      context "with required parameters" do
        before do
          allow(SkeletonElementGenerator).to receive(:generate)
            .and_return("<div></div>")
        end

        it "requires content_id parameter" do
          expect do
            view.skeleton_loader
          end.to raise_error(ArgumentError, "missing keyword: :content_id")
        end

        it "works with just content_id" do
          expect do
            view.skeleton_loader(content_id: "content_123")
          end.not_to raise_error
        end
      end
    end
  end
end
