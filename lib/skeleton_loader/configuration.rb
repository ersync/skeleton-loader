# frozen_string_literal: true

module SkeletonLoader
  # Configuration class manages settings for the SkeletonLoader gem.
  class Configuration
    TEMPLATE_DEFAULTS = {
      card: { width: 200, count: 3, per_row: 3 },
      comment: { width: 900, count: 2, per_row: 1 },
      default: { width: 900, count: 1, per_row: 1 },
      gallery: { width: 320, count: 3, per_row: 3 },
      paragraph: { width: 900, count: 1, per_row: 1 },
      product: { width: 320, count: 3, per_row: 3 },
      profile: { width: 320, count: 3, per_row: 3 }
    }.freeze

    attr_reader :scale, :template_paths, :animation_type,
                :additional_allowed_tags, :additional_allowed_attributes,
                :additional_allowed_css_properties, :templates

    def initialize
      reset!
    end

    # Resets all configuration options to their defaults.
    def reset!
      set_general_defaults
      set_template_defaults
      set_animation_defaults
      set_security_defaults
    end

    def base_options
      {
        scale: @scale,
        animation_type: @animation_type,
        additional_allowed_tags: @additional_allowed_tags,
        additional_allowed_attributes: @additional_allowed_attributes,
        additional_allowed_css_properties: @additional_allowed_css_properties
      }
    end

    # Returns the default options for a specific template type
    def template_defaults_for(type)
      @templates[type&.to_sym || :default] || @templates[:default]
    end

    private

    def set_general_defaults
      @scale = 1.0
      @template_paths = []
    end

    def set_template_defaults
      @templates = TEMPLATE_DEFAULTS.dup
    end

    def set_animation_defaults
      @animation_type = "sl-gradient"
    end

    def set_security_defaults
      @additional_allowed_tags = []
      @additional_allowed_attributes = {}
      @additional_allowed_css_properties = []
    end
  end
end
