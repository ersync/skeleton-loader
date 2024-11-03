module SkeletonLoader

  class SkeletonLoaderController < ApplicationController
    def show
      type = params[:type]
      target_id = params[:target_id]
      options = params[:options] || {}

      raise SkeletonLoader::Error, "target_id is required" if target_id.blank?

      # Step 1: Locate the template
      template_path = SkeletonLoader::TemplatePathFinder.find(type)
      raise SkeletonLoader::Error, "No template found for type '#{type}'" unless template_path

      # Step 2: Render the template with TemplateRenderer
      skeleton_content = SkeletonLoader::TemplateRenderer.render(template_path, options)

      # Step 3: Wrap in div structure similar to synchronous helper
      wrapped_content = ActionController::Base.helpers.content_tag(:div, skeleton_content.html_safe,
        class: "skeleton-loader",
        data: { target_id: target_id, target_display_type: options[:target_display_type] }
      )

      # Render final HTML output
      render html: wrapped_content
    rescue SkeletonLoader::Error => e
      render plain: "Error: #{e.message}", status: :bad_request
    end
  end


end