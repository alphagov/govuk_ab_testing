require 'spec_helper'

RSpec.describe GovukAbTesting::RequestedVariant do
  def ab_test
    GovukAbTesting::AbTest.new("education")
  end

  describe '#variant_name' do
    it "returns the variant" do
      activesupport_request = double(headers: { 'HTTP_GOVUK_ABTEST_EDUCATION' => 'A'})

      requested_variant = ab_test.requested_variant(activesupport_request)

      expect(requested_variant.variant_name).to eql("A")
    end
  end

  describe '#variant_a?' do
    it "returns the variant" do
      activesupport_request = double(headers: { 'HTTP_GOVUK_ABTEST_EDUCATION' => 'A'})

      requested_variant = ab_test.requested_variant(activesupport_request)

      expect(requested_variant.variant_a?).to eql(true)
      expect(requested_variant.variant_b?).to eql(false)
    end
  end

  describe '#variant_b?' do
    it "returns the variant" do
      activesupport_request = double(headers: { 'HTTP_GOVUK_ABTEST_EDUCATION' => 'B'})

      requested_variant = ab_test.requested_variant(activesupport_request)

      expect(requested_variant.variant_a?).to eql(false)
      expect(requested_variant.variant_b?).to eql(true)
    end
  end

  describe '#analytics_meta_tag' do
    it "returns the tag" do
      activesupport_request = double(headers: { 'HTTP_GOVUK_ABTEST_EDUCATION' => 'A'})

      requested_variant = ab_test.requested_variant(activesupport_request)

      expect(requested_variant.analytics_meta_tag).to eql("<meta name=\"govuk:ab-test\" content=\"Education:A\">")
    end
  end

  describe '#configure_response' do
    it "sets the correct header" do
      activesupport_request = double(headers: { 'HTTP_GOVUK_ABTEST_EDUCATION' => 'A'})
      requested_variant = ab_test.requested_variant(activesupport_request)
      response = double(headers: {})

      requested_variant.configure_response(response)

      expect(response.headers['Vary']).to eql('GOVUK-ABTest-Education')
    end

    it "crashes if the Vary header is already set" do
      activesupport_request = double(headers: { 'HTTP_GOVUK_ABTEST_EDUCATION' => 'A'})
      requested_variant = ab_test.requested_variant(activesupport_request)
      response = double(headers: { 'Vary' => 'Some vary header set by someone else'})

      expect {
        requested_variant.configure_response(response)
      }.to raise_error(StandardError)
    end
  end
end
