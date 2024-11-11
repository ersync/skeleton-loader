# frozen_string_literal: true

module SkeletonLoader
  RSpec.describe SkeletonLoaderController do
    before do
      @routes = SkeletonLoader::Engine.routes
    end

    let(:controller) { described_class.new }

    describe "#show" do
      let(:content_id) { "sample-content" }
      let(:markup) { "<div>Custom Content</div>" }

      context "when mode is predefined" do
        let(:predefined_params) do
          ActionController::Parameters.new(
            content_id: content_id,
            mode: "predefined",
            custom_option: "value"
          )
        end

        before do
          allow(controller).to receive(:params).and_return(predefined_params)
          allow(controller).to receive(:render)
        end

        # rubocop:disable RSpec/ExampleLength
        it "generates skeleton with correct parameters" do
          allow(SkeletonElementGenerator).to receive(:generate)
            .with(content_id: content_id, options: { "custom_option" => "value" }, context: :controller)
            .and_return("<div>Skeleton</div>")
          controller.show
          expect(SkeletonElementGenerator).to have_received(:generate)
            .with(content_id: content_id, options: { "custom_option" => "value" }, context: :controller)
        end
        # rubocop:enable RSpec/ExampleLength

        it "renders the generated skeleton" do
          allow(SkeletonElementGenerator).to receive(:generate)
            .and_return("<div>Skeleton</div>")

          controller.show
          expect(controller).to have_received(:render).with(html: "<div>Skeleton</div>")
        end
      end

      context "when mode is custom" do
        let(:custom_params) do
          ActionController::Parameters.new(
            content_id: content_id,
            mode: "custom",
            markup: markup
          )
        end

        before do
          allow(controller).to receive(:params).and_return(custom_params)
          allow(controller).to receive(:render)
        end

        it "calls generator with correct content_id and context" do
          allow(SkeletonElementGenerator).to receive(:generate) { markup }

          controller.show

          expect(SkeletonElementGenerator).to have_received(:generate)
            .with(content_id: content_id, context: :controller)
        end

        # rubocop:disable RSpec/ExampleLength
        it "passes the markup through the generator" do
          allow(SkeletonElementGenerator).to receive(:generate) { |&block|
            block.call
            markup
          }
          controller.show
          expect(SkeletonElementGenerator).to have_received(:generate)
        end
        # rubocop:enable RSpec/ExampleLength

        it "renders the final markup" do
          allow(SkeletonElementGenerator).to receive(:generate) { markup }

          controller.show

          expect(controller).to have_received(:render).with(html: markup)
        end
      end

      context "when an error occurs" do
        let(:error_params) do
          ActionController::Parameters.new(
            content_id: content_id,
            mode: "predefined"
          )
        end

        let(:error_message) { "Test error" }

        before do
          allow(controller).to receive(:params).and_return(error_params)
          allow(controller).to receive(:render)
          allow(SkeletonElementGenerator).to receive(:generate)
            .and_raise(StandardError, error_message)
        end

        it "logs the error message" do
          allow(Rails.logger).to receive(:error)
          controller.show
          expect(Rails.logger).to have_received(:error).with("SkeletonLoader Error: #{error_message}")
        end

        it "logs the backtrace" do
          allow(Rails.logger).to receive(:error)
          controller.show
          expect(Rails.logger).to have_received(:error).with(kind_of(String)).twice
        end

        it "renders error response with correct status" do
          allow(Rails.logger).to receive(:error)
          controller.show
          expect(controller).to have_received(:render).with(json: { error: error_message, backtrace: [] },
                                                            status: :unprocessable_entity)
        end
      end
    end

    describe "#process_params" do
      let(:complex_params) do
        ActionController::Parameters.new(
          content_id: "test",
          controller: "controller",
          action: "action",
          format: "json",
          mode: "predefined",
          markup: "<div></div>",
          custom_option: "custom_value",
          another_option: "another_value"
        )
      end

      before do
        allow(controller).to receive(:params).and_return(complex_params)
      end

      it "includes only custom parameters" do
        filtered_params = controller.send(:process_params)

        expect(filtered_params).to eq({
                                        "custom_option" => "custom_value",
                                        "another_option" => "another_value"
                                      })
      end

      it "excludes system parameters" do
        filtered_params = controller.send(:process_params)

        expect(filtered_params.keys).not_to include(
          "content_id", "controller", "action", "format", "mode", "markup"
        )
      end
    end
  end
end
