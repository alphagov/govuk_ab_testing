module GovukAbTesting
  class AbTest
    attr_reader :ab_test_name, :allowed_variants, :control_variant

    alias_method :name, :ab_test_name

    # @param request [String] the name of the A/B test
    # @param allowed_variants [Array] an array of Strings representing the
    # possible variants
    # @param control_variant [String] the control variant (typically 'A')
    def initialize(ab_test_name, allowed_variants: %w[A B], control_variant: "A")
      @ab_test_name = ab_test_name
      @allowed_variants = allowed_variants
      @control_variant = control_variant
    end

    # @param request [ActionDispatch::Http::Headers] the `request.headers` in
    # the controller.
    def requested_variant(request_headers)
      RequestedVariant.new(self, request_headers)
    end

    # Internal name of the header
    def request_header
      "HTTP_GOVUK_ABTEST_#{ab_test_name.upcase}"
    end

    def response_header
      "GOVUK-ABTest-#{meta_tag_name}"
    end

    def meta_tag_name
      ab_test_name
    end
  end
end
