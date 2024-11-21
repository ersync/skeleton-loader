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
      params_to_process = params.to_unsafe_h
                                .except("controller", "action", "format", "content_id", "mode", "markup")
                                .transform_keys(&:to_sym)

      convert_numeric_params(params_to_process)
      params_to_process
    end

    def convert_numeric_params(params)
      %i[scale count width per_row].each do |key|
        params[key] = params[key].to_f if key == :scale && params[key]
        params[key] = params[key].to_i if %i[count width per_row].include?(key) && params[key]
      end
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
