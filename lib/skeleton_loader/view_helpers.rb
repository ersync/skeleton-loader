# frozen_string_literal: true

require "action_view"

module SkeletonLoader
  # Provides helper methods for rendering skeleton loaders in views.
  module ViewHelpers
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::CaptureHelper

    def skeleton_loader(type = nil, target_id:, **options, &block)
      raise SkeletonLoader::Error, "target_id is required" if target_id.blank?

      skeleton_content = SkeletonContentGenerator.generate(type: type, options: options, &block)
      skeleton_content = capture(&skeleton_content) if skeleton_content.is_a?(Proc)

      content_tag(:div, skeleton_content,
                  class: "skeleton-loader",
                  data: {
                    target_id: target_id,
                    target_display_type: options[:target_display_type]
                  })
    end
  end
end
