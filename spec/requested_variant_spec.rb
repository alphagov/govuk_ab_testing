require 'spec_helper'

RSpec.describe GovukAbTesting::RequestedVariant do
  def ab_test
    GovukAbTesting::AbTest.new("EducationNav", dimension: 500)
  end

  describe '#variant_name' do
    it "returns the variant" do
      request_headers = { 'HTTP_GOVUK_ABTEST_EDUCATIONNAV' => 'A' }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant_name).to eql("A")
    end
  end

  describe '#variant_a?' do
    it "returns the variant" do
      request_headers = { 'HTTP_GOVUK_ABTEST_EDUCATIONNAV' => 'A' }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant_a?).to eql(true)
      expect(requested_variant.variant_b?).to eql(false)
    end
  end

  describe '#variant_b?' do
    it "returns the variant" do
      request_headers = { 'HTTP_GOVUK_ABTEST_EDUCATIONNAV' => 'B' }

      requested_variant = ab_test.requested_variant(request_headers)

      expect(requested_variant.variant_a?).to eql(false)
      expect(requested_variant.variant_b?).to eql(true)
    end
  end

  describe '#analytics_meta_tag' do
    it "returns the tag with the analytics dimension" do
      request_headers = { 'HTTP_GOVUK_ABTEST_EDUCATIONNAV' => 'A' }

      requested_variant = GovukAbTesting::AbTest.new("EducationNav", dimension: 207).
        requested_variant(request_headers)

      expect(requested_variant.analytics_meta_tag).to eql(
        "<meta name=\"govuk:ab-test\" content=\"EducationNav:A\" data-analytics-dimension=\"207\">")
    end
  end

  describe '#configure_response' do
    it "sets the correct header" do
      request_headers = { 'HTTP_GOVUK_ABTEST_EDUCATIONNAV' => 'A' }
      requested_variant = ab_test.requested_variant(request_headers)
      response = double(headers: {})

      requested_variant.configure_response(response)

      expect(response.headers['Vary']).to eql('GOVUK-ABTest-EducationNav')
    end

    it "appends if the Vary header is already set" do
      request_headers = { 'HTTP_GOVUK_ABTEST_EDUCATIONNAV' => 'A' }
      requested_variant = ab_test.requested_variant(request_headers)
      response = double(headers: { 'Vary' => 'GOVUK-OtherHeader' })

      requested_variant.configure_response(response)

      expect(response.headers['Vary']).to eql('GOVUK-OtherHeader, GOVUK-ABTest-EducationNav')
    end
  end
end
