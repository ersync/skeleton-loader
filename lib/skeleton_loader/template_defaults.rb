# frozen_string_literal: true

module SkeletonLoader
  #
  # Provides default style configurations for pre-built templates.
  #
  class TemplateDefaults
    class << self
      def for_template(template_name)
        return {} if template_name.nil?

        defaults = template_defaults[template_name.to_sym]
        defaults || {}
      end

      private

      # rubocop:disable Metrics/MethodLength
      def template_defaults
        @template_defaults ||= {
          card: {
            width: "140px",
            height: "255px",
            padding: "0",
            margin: "0 auto",
            background_color: "#e5e7eb",
            border_radius: "0.5rem",
            border_width: "1px",
            animation_type: "animation-pulse"
          }.freeze,
          comment: {
            width: "100%",
            height: "auto",
            padding: "1rem",
            margin: "0.5rem 0",
            background_color: "#e5e7eb90",
            border_radius: "8px",
            animation_duration: "2s",
            animation_type: "animation-pulse"
          }.freeze,
          gallery: {
            width: "300px",
            height: "auto",
            padding: "0.5rem",
            margin: "0.5rem auto",
            background_color: "#e5e7eb",
            border_radius: "8px",
            animation_duration: "2.2s",
            animation_type: "animation-pulse"
          }.freeze,
          paragraph: {
            width: "300px",
            height: "auto",
            padding: "0.5rem",
            margin: "0.5rem auto",
            background_color: "#e5e7eb90",
            border_radius: "8px",
            animation_duration: "2.2s",
            animation_type: "animation-pulse"
          }.freeze,
          product: {
            width: "300px",
            height: "auto",
            padding: "0.5rem",
            margin: "0.5rem auto",
            background_color: "#e5e7eb",
            border_radius: "8px",
            animation_duration: "2.2s",
            animation_type: "animation-pulse"
          }.freeze
        }.freeze
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end