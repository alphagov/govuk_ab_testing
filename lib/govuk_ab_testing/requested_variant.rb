module GovukAbTesting
  class RequestedVariant
    attr_reader :ab_test, :request

    # @param ab_test_name [AbTest] Lowercase A/B test name, like `example`
    # @param request [ApplicationController::Request] the `request` in the
    # controller.
    def initialize(ab_test, request)
      @ab_test = ab_test
      @request = request
    end

    # Get the bucket this user is in
    #
    # @return [String] the current variant, "A" or "B"
    def variant_name
      request.headers[ab_test.request_header] == "B" ? "B" : "A"
    end

    # @return [Boolean] if the user is to be served variant A
    def variant_a?
      variant_name == "A"
    end

    # @return [Boolean] if the user is to be served variant B
    def variant_b?
      variant_name == "B"
    end

    # Configure the response
    #
    # @param [ApplicationController::Response] the `response` in the controller
    def configure_response(response)
      raise "We're trying to set the Vary header, but this would override the current header" if response.headers['Vary']
      response.headers['Vary'] = ab_test.response_header
    end

    # HTML meta tag used to track the results of your experiment
    #
    # @return [String]
    def analytics_meta_tag
      '<meta name="govuk:ab-test" content="' + ab_test.meta_tag_name + ':' + variant_name + '">'
    end
  end
end
