# frozen_string_literal: true

module SkeletonLoader
  #
  # Manages configuration settings for the SkeletonLoader gem.
  # Initializes with default values and can convert settings to a hash.
  #
  class Configuration
    attr_accessor :scale,
                  :template_paths,
                  # Profile
                  :profile_width, :profile_count, :profile_per_row,
                  # Paragraph
                  :paragraph_width, :line_count,
                  # Gallery
                  :gallery_width, :image_count, :image_per_row,
                  # Card
                  :card_width, :card_count, :card_per_row,
                  # Product
                  :product_width, :product_count, :product_per_row,
                  # Animation
                  :animation_type,
                  # Security
                  :additional_allowed_tags,
                  :additional_allowed_attributes,
                  :additional_allowed_css_properties

    def initialize
      set_general_defaults
      set_template_defaults
      set_animation_defaults
      set_security_defaults
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

    def set_general_defaults
      @scale = 1.0
      @template_paths = []
    end

    def set_template_defaults
      set_profile_defaults
      set_paragraph_defaults
      set_gallery_defaults
      set_card_defaults
      set_product_defaults
    end

    def set_profile_defaults
      @profile_width = 350
      @profile_count = 1
      @profile_per_row = 1
    end

    def set_paragraph_defaults
      @paragraph_width = 900
      @line_count = 4
    end

    def set_gallery_defaults
      @gallery_width = 300
      @image_count = 3
      @image_per_row = 3
    end

    def set_card_defaults
      @card_width = 200
      @card_count = 3
      @card_per_row = 3
    end

    def set_product_defaults
      @product_width = 320
      @product_count = 3
      @product_per_row = 3
    end

    def set_animation_defaults
      @animation_type = "animation-gradient"
    end

    def set_security_defaults
      @additional_allowed_tags = []
      @additional_allowed_attributes = {}
      @additional_allowed_css_properties = []
    end
  end
end
