# frozen_string_literal: true

# rubocop:disable RSpec/ExampleLength

RSpec.describe SkeletonLoader::TemplateDefaults do
  describe ".for_template" do
    context "when template exists" do
      it "returns card template defaults" do
        defaults = described_class.for_template(:card)

        expect(defaults).to include(
          width: "140px",
          height: "255px",
          background_color: "#e5e7eb",
          border_radius: "0.5rem"
        )
      end

      it "returns comment template defaults" do
        defaults = described_class.for_template(:comment)

        expect(defaults).to include(
          width: "100%",
          height: "auto",
          padding: "1rem",
          animation_duration: "2s"
        )
      end

      it "returns gallery template defaults" do
        defaults = described_class.for_template(:gallery)

        expect(defaults).to include(
          width: "300px",
          height: "auto",
          background_color: "#e5e7eb",
          animation_duration: "2.2s"
        )
      end

      it "returns paragraph template defaults" do
        defaults = described_class.for_template(:paragraph)

        expect(defaults).to include(
          width: "300px",
          height: "auto",
          background_color: "#e5e7eb90",
          animation_type: "animation-pulse"
        )
      end

      it "returns product template defaults" do
        defaults = described_class.for_template(:product)

        expect(defaults).to include(
          width: "300px",
          height: "auto",
          padding: "0.5rem",
          animation_type: "animation-pulse"
        )
      end

      it "returns frozen hash for all templates" do
        %i[card comment gallery paragraph product].each do |template|
          expect(described_class.for_template(template)).to be_frozen
        end
      end
    end

    context "when template does not exist" do
      it "returns empty hash for unknown template" do
        expect(described_class.for_template(:unknown)).to eq({})
      end

      it "returns empty hash for nil template" do
        expect(described_class.for_template(nil)).to eq({})
      end
    end

    context "when using string template names" do
      it "handles string template names" do
        expect(described_class.for_template("card")).to include(
          width: "140px",
          height: "255px"
        )
      end
    end
  end

  describe ".template_defaults" do
    it "returns frozen hash" do
      # Using send to test private method
      defaults = described_class.send(:template_defaults)
      expect(defaults).to be_frozen
    end

    it "returns frozen values for each template" do
      defaults = described_class.send(:template_defaults)
      defaults.each_value do |template_defaults|
        expect(template_defaults).to be_frozen
      end
    end
  end
end
# rubocop:enable RSpec/ExampleLength
