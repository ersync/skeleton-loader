# frozen_string_literal: true

# rubocop:disable Metrics/MethodLength
# rubocop:disable Rails/OutputSafety

module SkeletonLoader
  #
  # Sanitizes HTML content for skeleton loaders, allowing specific tags,
  # attributes, and CSS properties while preventing XSS attacks.
  #
  class SkeletonSanitizer
    def self.sanitize(content)
      config = SkeletonLoader.configuration

      sanitizer_class = begin
        Rails::HTML4::SafeListSanitizer
      rescue StandardError
        Rails::HTML::SafeListSanitizer
      end
      sanitizer = sanitizer_class.new

      default_css_properties = %w[
        # Layout
        display
        grid grid-template-columns grid-template-rows
        gap
        width height
        padding padding-bottom padding-left padding-right padding-top
        margin margin-bottom margin-left margin-right margin-top

        # Flexbox
        flex flex-direction flex-shrink flex-grow
        align-items justify-content

        # Visual
        border-radius
        overflow

        # Animations (for skeleton loading effects)
        animation
        background background-color
      ].uniq

      sanitizer.sanitize(
        content,
        tags: sanitizer_class.allowed_tags + %w[div style],
        attributes: sanitizer_class.allowed_attributes + %w[
          style
          class
          data-*
          aria-*
        ],
        css: {
          properties: default_css_properties + config.additional_allowed_css_properties
        }
      ).html_safe
    end
  end
end

# rubocop:enable Metrics/MethodLength
# rubocop:enable Rails/OutputSafety
