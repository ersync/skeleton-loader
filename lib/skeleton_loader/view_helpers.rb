module SkeletonLoader
  module ViewHelpers
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::CaptureHelper

    def skeleton_loader(type = nil, target_id:, **options, &block)
      # Log where this method is coming from
      Rails.logger.debug "skeleton_loader called from: #{self.class.name}"
      Rails.logger.debug "skeleton_loader method defined in: #{method(:skeleton_loader).source_location}"

      raise SkeletonLoader::Error, "target_id is required" if target_id.blank?

      # Debug content generation
      skeleton_content = SkeletonContentGenerator.generate(type: type, options: options, &block)
      skeleton_content = capture(&skeleton_content) if skeleton_content.is_a?(Proc)

      result = content_tag(:div, skeleton_content,
        class: "skeleton-loader",
        data: {
          target_id: target_id,
          target_display_type: options[:target_display_type]
        })

      result
    rescue => e
      Rails.logger.error "Error in skeleton_loader helper: #{e.message}"
      raise
    end
  end
end