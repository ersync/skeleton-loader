# frozen_string_literal: true

module SkeletonLoader
  # Handles async requests to generate and render loading skeletons
  class SkeletonLoaderController < ActionController::Base
    def show
      content_id = params[:content_id]
      mode = params[:mode]
      wrapped_content = mode == "custom" ? handle_custom_template(content_id) : handle_predefined_template(content_id)
      render html: wrapped_content
    rescue StandardError => e
      handle_error(e)
    end

    private

    def handle_predefined_template(content_id)
      options = process_params
      SkeletonElementGenerator.generate(
        content_id: content_id,
        options: options,
        context: :controller
      )
    end

    def handle_custom_template(content_id)
      markup = params[:markup]
      SkeletonElementGenerator.generate(
        content_id: content_id,
        context: :controller
      ) { markup }
    end

    def process_params
      params.to_unsafe_h
            .except("content_id", "controller", "action", "format", "mode", "markup")
            .transform_keys(&:to_sym)
    end

    def handle_error(error)
      Rails.logger.error "SkeletonLoader Error: #{error.message}"
      Rails.logger.error error.backtrace.join("\n")

      render json: {
        error: error.message,
        backtrace: Rails.env.development? ? error.backtrace : []
      }, status: :unprocessable_entity
    end
  end
end
