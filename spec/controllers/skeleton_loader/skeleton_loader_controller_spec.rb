# frozen_string_literal: true

module SkeletonLoader
  RSpec.describe SkeletonLoaderController do
    before do
      @routes = SkeletonLoader::Engine.routes
    end

    let(:controller) { described_class.new }
    let(:content_id) { "sample-content" }

    describe "#show" do
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

        it "generates skeleton with correct parameters" do
          allow(SkeletonElementGenerator).to receive(:generate).and_return("<div>Skeleton</div>")

          controller.show

          expect(SkeletonElementGenerator).to have_received(:generate)
            .with(content_id: content_id, options: { "custom_option" => "value" }, context: :controller)
        end

        it "renders the generated skeleton" do
          allow(SkeletonElementGenerator).to receive(:generate).and_return("<div>Skeleton</div>")
          controller.show
          expect(controller).to have_received(:render).with(html: "<div>Skeleton</div>")
        end
      end

      context "when mode is custom" do
        let(:markup) { "<div>Custom Content</div>" }
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

        it "passes correct parameters to generator" do
          allow(SkeletonElementGenerator).to receive(:generate).and_return(markup)
          controller.show
          expect(SkeletonElementGenerator).to have_received(:generate)
            .with(content_id: content_id, context: :controller)
        end

        it "passes block that returns markup" do
          allow(SkeletonElementGenerator).to receive(:generate) do |&block|
            expect(block.call).to eq(markup)
          end
          controller.show
        end

        it "renders the final markup" do
          allow(SkeletonElementGenerator).to receive(:generate) { markup }
          controller.show
          expect(controller).to have_received(:render).with(html: markup)
        end
      end

      context "when error handling" do
        let(:error_params) { { content_id: content_id, mode: "predefined" } }
        let(:env_double) { double("Environment") }

        before do
          allow(controller).to receive(:params).and_return(ActionController::Parameters.new(error_params))
          allow(SkeletonElementGenerator).to receive(:generate).and_raise(StandardError, "Test error")
          allow(Rails.logger).to receive(:error)
          allow(Rails).to receive(:env).and_return(env_double)
          allow(controller).to receive(:render)
        end

        context "when in development environment" do
          before { allow(env_double).to receive(:development?).and_return(true) }

          it "renders error with backtrace" do
            controller.show
            expect(controller).to have_received(:render).with(
              json: { error: "Test error", backtrace: kind_of(Array) },
              status: :unprocessable_entity
            )
          end
        end

        context "when in production environment" do
          before { allow(env_double).to receive(:development?).and_return(false) }

          it "renders error without backtrace" do
            controller.show
            expect(controller).to have_received(:render).with(
              json: { error: "Test error", backtrace: [] },
              status: :unprocessable_entity
            )
          end
        end
      end
    end

    describe "#process_params" do
      let(:params) do
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

      before { allow(controller).to receive(:params).and_return(params) }

      it "filters system parameters" do
        filtered = controller.send(:process_params)
        expect(filtered).to eq({
                                 "custom_option" => "custom_value",
                                 "another_option" => "another_value"
                               })
      end
    end
  end
end
