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
          paragraph: {
            base_width: 900,
            line_count: 4,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze,
          profile: {
            base_width: 350,
            user_profile_count: 1,
            user_profile_per_row: 1,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze,
          gallery: {
            base_width: 300,
            image_count: 3,
            image_per_row: 3,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze,
          card: {
            base_width: 200,
            card_count: 3,
            card_per_row: 3,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze,
          product: {
            base_width: 320,
            product_count: 2,
            product_per_row: 2,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze,
          default: {
            base_width: 700,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze,
          comment: {
            base_width: 700,
            border_enabled: false,
            border_color: "#e5e7eb",
            animation_type: "animation-pulse"
          }.freeze
        }.freeze
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
