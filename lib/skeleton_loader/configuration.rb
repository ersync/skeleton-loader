# frozen_string_literal: true

module SkeletonLoader
  #
  # Manages configuration settings for the SkeletonLoader gem, including layout, style, and animation attributes.
  # Initializes with default values and can convert settings to a hash.
  #
  class Configuration
    # Layout attributes
    attr_accessor :width,
                  :height,
                  :item_count,
                  :target_display_type

    # Style attributes
    attr_accessor :background_color,
                  :highlight_color,
                  :border_radius

    # Animation attributes
    attr_accessor :animation_enabled,
                  :animation_duration,
                  :animation_type

    # Spacing attributes
    attr_accessor :padding,
                  :margin,
                  :gap

    # Content attributes
    attr_accessor :content_variant,
                  :variant,
                  :template_paths,
                  :aria_label

    def initialize
      set_layout_defaults
      set_style_defaults
      set_animation_defaults
      set_spacing_defaults
      set_content_defaults
    end

    def to_h
      instance_variables.map do |var|
        [
          var.to_s.delete("@").to_sym,
          instance_variable_get(var)
        ]
      end.to_h
    end

    private

    def set_layout_defaults
      @width = "100%"
      @height = "auto"
      @item_count = 1
      @target_display_type = "block"
    end

    def set_style_defaults
      @background_color = "#e0e0e0"
      @highlight_color = "#f0f0f0"
      @border_radius = "4px"
    end

    def set_animation_defaults
      @animation_enabled = true
      @animation_duration = "1.5s"
      @animation_type = "shine"
    end

    def set_spacing_defaults
      @padding = "10px"
      @margin = "0"
      @gap = "10px"
    end

    def set_content_defaults
      @content_variant = "text"
      @variant = "default"
      @template_paths = []
      @aria_label = "Loading content"
    end
  end
end
