# frozen_string_literal: true

module SkeletonLoader
  # Provides helper methods for rendering skeleton loaders in views.
  module ViewHelpers
    def skeleton_loader(content_id:, **options, &block)
      SkeletonElementGenerator.generate(content_id: content_id, options: options, &block)
    rescue StandardError => e
      handle_error(e)
    end

    private

    def handle_error(error)
      Rails.logger.error "Error in skeleton_loader helper: #{error.message}"
      raise
    end
  end
end
