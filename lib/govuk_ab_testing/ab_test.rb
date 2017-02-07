module GovukAbTesting
  class AbTest
    attr_reader :ab_test_name

    def initialize(ab_test_name)
      @ab_test_name = ab_test_name
    end

    # @param request [ApplicationController::Request] the `request` in the
    # controller.
    def requested_variant(request)
      RequestedVariant.new(self, request)
    end

    # Internal name of the header
    def request_header
      "HTTP_GOVUK_ABTEST_#{ab_test_name.upcase}"
    end

    def response_header
      "GOVUK-ABTest-#{meta_tag_name}"
    end

    # `example` -> `Example`
    def meta_tag_name
      ab_test_name.capitalize
    end
  end
end
