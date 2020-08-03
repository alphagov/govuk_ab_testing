require "spec_helper"

RSpec.describe GovukAbTesting::RequestedVariant do
  def ab_test
    GovukAbTesting::AbTest.new("EducationNav", dimension: 500)
  end

  describe "#variant_name" do
    it "returns the variant" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "A" }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant_name).to eql("A")
    end
  end

  describe "#variant_a?" do
    it "returns the variant" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "A" }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant_a?).to eql(true)
      expect(requested_variant.variant_b?).to eql(false)
    end
  end

  describe "#variant_b?" do
    it "returns the variant" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "B" }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant_a?).to eql(false)
      expect(requested_variant.variant_b?).to eql(true)
    end
  end

  describe "#variant?" do
    it "returns the variant" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "B" }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant?("A")).to eql(false)
      expect(requested_variant.variant?("B")).to eql(true)
    end

    it "raises with an invalid variant name" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "B" }

      requested_variant = ab_test.requested_variant(request_headers)

      expect {
        requested_variant.variant?("InvalidName")
      }.to raise_error(
        "Invalid variant name 'InvalidName'. Allowed variants are: #{ab_test.allowed_variants}",
      )
    end
  end

  describe "#analytics_meta_tag" do
    it "returns the tag with the analytics dimension" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "A" }

      requested_variant = GovukAbTesting::AbTest.new("EducationNav", dimension: 207)
        .requested_variant(request_headers)

      expect(requested_variant.analytics_meta_tag).to eql(
        "<meta name=\"govuk:ab-test\" content=\"EducationNav:A\" data-analytics-dimension=\"207\" data-allowed-variants=\"A,B\">",
      )
    end
  end

  describe "#configure_response" do
    it "sets the correct header" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "A" }
      requested_variant = ab_test.requested_variant(request_headers)
      response = double(headers: {})

      requested_variant.configure_response(response)

      expect(response.headers["Vary"]).to eql("GOVUK-ABTest-EducationNav")
    end

    it "appends if the Vary header is already set" do
      request_headers = { "HTTP_GOVUK_ABTEST_EDUCATIONNAV" => "A" }
      requested_variant = ab_test.requested_variant(request_headers)
      response = double(headers: { "Vary" => "GOVUK-OtherHeader" })

      requested_variant.configure_response(response)

      expect(response.headers["Vary"]).to eql("GOVUK-OtherHeader, GOVUK-ABTest-EducationNav")
    end
  end

  context "with custom variants" do
    let(:ab_test) do
      GovukAbTesting::AbTest.new(
        "NewTitleTest",
        dimension: 500,
        allowed_variants: %w[NoTitleChange Title1 Title2],
        control_variant: "NoTitleChange",
      )
    end

    describe "#variant_name" do
      %w[NoTitleChange Title1 Title2].each do |variant_name|
        it "returns the variant '#{variant_name}' when the header exists" do
          request_headers = { "HTTP_GOVUK_ABTEST_NEWTITLETEST" => variant_name }

          requested_variant = ab_test.requested_variant(request_headers)

          expect(requested_variant.variant_name).to eql(variant_name)
        end
      end

      it "defaults to the control group when no header is given" do
        requested_variant = ab_test.requested_variant({})

        expect(requested_variant.variant_name).to eql("NoTitleChange")
      end
    end

    describe "#analytics_meta_tag" do
      it "returns the tag with the analytics dimension" do
        request_headers = { "HTTP_GOVUK_ABTEST_NEWTITLETEST" => "Title1" }

        requested_variant = ab_test.requested_variant(request_headers)

        expect(requested_variant.analytics_meta_tag).to eql(
          "<meta name=\"govuk:ab-test\" content=\"NewTitleTest:Title1\" data-analytics-dimension=\"500\" data-allowed-variants=\"NoTitleChange,Title1,Title2\">",
        )
      end
    end
  end
end
