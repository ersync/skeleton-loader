# frozen_string_literal: true

module SkeletonLoader
  # Handles async requests to generate and render loading skeletons
  class SkeletonLoaderController < ApplicationController
    def show
      options = process_params || {}
      content_id = params[:content_id]
      raise SkeletonLoader::Error, "content_id is required" if content_id.blank?

      wrapped_content = SkeletonBuilder.new(
        type: params[:type], content_id: params[:content_id], options: options
      ).generate

      safe_content = ActionController::Base.helpers.sanitize(wrapped_content)

      render html: safe_content
    rescue StandardError => e
      handle_error(e)
    end

    private

    def process_params
      params.to_unsafe_h.except(
        "type",
        "content_id",
        "controller",
        "action",
        "format"
      ).transform_keys(&:to_sym)
    end

    def handle_error(error)
      render json: {
        error: error.message,
        backtrace: error.backtrace
      }, status: :unprocessable_entity
    end
  end
end
