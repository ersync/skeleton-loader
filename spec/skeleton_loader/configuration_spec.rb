# frozen_string_literal: true

# rubocop:disable RSpec/NestedGroups

RSpec.describe SkeletonLoader::Configuration do
  subject(:config) { described_class.new }

  describe "initialization" do
    context "with general defaults" do
      it "sets scale" do
        expect(config.scale).to eq(1.0)
      end
    end

    context "with template defaults" do
      context "with profile settings" do
        it "sets profile_width" do
          expect(config.profile_width).to eq(350)
        end

        it "sets profile_count" do
          expect(config.profile_count).to eq(1)
        end

        it "sets profile_per_row" do
          expect(config.profile_per_row).to eq(1)
        end
      end

      context "with paragraph settings" do
        it "sets paragraph_width" do
          expect(config.paragraph_width).to eq(900)
        end

        it "sets line_count" do
          expect(config.line_count).to eq(4)
        end
      end

      context "with gallery settings" do
        it "sets gallery_width" do
          expect(config.gallery_width).to eq(300)
        end

        it "sets image_count" do
          expect(config.image_count).to eq(3)
        end

        it "sets image_per_row" do
          expect(config.image_per_row).to eq(3)
        end
      end

      context "with card settings" do
        it "sets card_width" do
          expect(config.card_width).to eq(200)
        end

        it "sets card_count" do
          expect(config.card_count).to eq(3)
        end

        it "sets card_per_row" do
          expect(config.card_per_row).to eq(3)
        end
      end

      context "with product settings" do
        it "sets product_width" do
          expect(config.product_width).to eq(320)
        end

        it "sets product_count" do
          expect(config.product_count).to eq(3)
        end

        it "sets product_per_row" do
          expect(config.product_per_row).to eq(3)
        end
      end
    end

    context "with animation defaults" do
      it "sets animation_type" do
        expect(config.animation_type).to eq("animation-gradient")
      end
    end

    context "with security defaults" do
      it "sets additional_allowed_tags" do
        expect(config.additional_allowed_tags).to eq([])
      end

      it "sets additional_allowed_attributes" do
        expect(config.additional_allowed_attributes).to eq({})
      end

      it "sets additional_allowed_css_properties" do
        expect(config.additional_allowed_css_properties).to eq([])
      end
    end
  end

  describe "attribute modification" do
    context "when modifying general attributes" do
      it "allows scale modification" do
        config.scale = 1.5
        expect(config.scale).to eq(1.5)
      end
    end

    context "when modifying template attributes" do
      context "when modifying profile settings" do
        it "allows profile_width modification" do
          config.profile_width = 400
          expect(config.profile_width).to eq(400)
        end

        it "allows profile_count modification" do
          config.profile_count = 2
          expect(config.profile_count).to eq(2)
        end

        it "allows profile_per_row modification" do
          config.profile_per_row = 2
          expect(config.profile_per_row).to eq(2)
        end
      end

      context "when modifying paragraph settings" do
        it "allows paragraph_width modification" do
          config.paragraph_width = 1000
          expect(config.paragraph_width).to eq(1000)
        end

        it "allows line_count modification" do
          config.line_count = 6
          expect(config.line_count).to eq(6)
        end
      end

      context "when modifying gallery settings" do
        it "allows gallery_width modification" do
          config.gallery_width = 400
          expect(config.gallery_width).to eq(400)
        end

        it "allows image_count modification" do
          config.image_count = 4
          expect(config.image_count).to eq(4)
        end

        it "allows image_per_row modification" do
          config.image_per_row = 4
          expect(config.image_per_row).to eq(4)
        end
      end
    end

    context "when modifying animation attributes" do
      it "allows animation_type modification" do
        config.animation_type = "fade"
        expect(config.animation_type).to eq("fade")
      end
    end

    context "when modifying security attributes" do
      it "allows additional_allowed_tags modification" do
        tags = %w[div span]
        config.additional_allowed_tags = tags
        expect(config.additional_allowed_tags).to eq(tags)
      end

      it "allows additional_allowed_attributes modification" do
        attrs = { "div" => ["class"] }
        config.additional_allowed_attributes = attrs
        expect(config.additional_allowed_attributes).to eq(attrs)
      end

      it "allows additional_allowed_css_properties modification" do
        props = %w[background-color color]
        config.additional_allowed_css_properties = props
        expect(config.additional_allowed_css_properties).to eq(props)
      end
    end
  end

  describe "#to_h" do
    let(:expected_keys) do
      %i[
        scale
        template_paths
        profile_width profile_count profile_per_row
        paragraph_width line_count
        gallery_width image_count image_per_row
        card_width card_count card_per_row
        product_width product_count product_per_row
        animation_type
        additional_allowed_tags
        additional_allowed_attributes
        additional_allowed_css_properties
      ]
    end

    it "converts configuration to hash with correct keys" do
      result = config.to_h
      expect(result.keys).to match_array(expected_keys)
    end

    it "preserves default profile width value" do
      expect(config.to_h[:profile_width]).to eq(350)
    end

    it "preserves default line count value" do
      expect(config.to_h[:line_count]).to eq(4)
    end

    it "reflects modified values in hash output" do
      config.profile_width = 500
      expect(config.to_h[:profile_width]).to eq(500)
    end
  end
end
# rubocop:enable RSpec/NestedGroups
