module GovukAbTesting
  class AbTest
    attr_reader :ab_test_name

    # @param request [String] the name of the A/B test
    # @param dimension [Integer] the dimension registered with Google Analytics
    # for this specific A/B test
    def initialize(ab_test_name, dimension:)
      @ab_test_name = ab_test_name
      @dimension = dimension
    end

    # @param request [ApplicationController::Request] the `request` in the
    # controller.
    def requested_variant(request)
      RequestedVariant.new(self, request, @dimension)
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
