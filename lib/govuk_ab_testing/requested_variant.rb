module GovukAbTesting
  class RequestedVariant
    attr_reader :ab_test, :request_headers

    # @param ab_test [AbTest] the A/B test being performed
    # @param request_headers [ActionDispatch::Http::Headers] the
    # `request.headers` in the controller.
    # @param dimension [Integer] the dimension registered with Google Analytics
    # for this specific A/B test
    def initialize(ab_test, request_headers, dimension)
      @ab_test = ab_test
      @request_headers = request_headers
      @dimension = dimension
    end

    # Get the bucket this user is in
    #
    # @return [String] the current variant, "A" or "B"
    def variant_name
      variant = ab_test.allowed_variants.find do |allowed_variant|
        allowed_variant == request_headers[ab_test.request_header]
      end

      variant || ab_test.control_variant
    end

    # @return [Boolean] if the user is to be served variant A
    def variant_a?
      warn 'DEPRECATION WARNING: the method `variant_a?` is deprecated. use `variant?("A")` instead'

      variant_name == "A"
    end

    # @return [Boolean] if the user is to be served variant B
    def variant_b?
      warn 'DEPRECATION WARNING: the method `variant_b?` is deprecated. use `variant?("B")` instead'

      variant_name == "B"
    end

    # Check if the user should be served a specific variant
    #
    # @param [String or Symbol] the name of the variant
    #
    # @return [Boolean] if the user is to be served variant :name
    def variant?(name)
      error_message =
        "Invalid variant name '#{name}'. Allowed variants are: #{ab_test.allowed_variants}"

      raise error_message unless ab_test.allowed_variants.include?(name.to_s)

      variant_name == name.to_s
    end

    # Configure the response
    #
    # @param [ApplicationController::Response] the `response` in the controller
    def configure_response(response)
      response.headers["Vary"] = [response.headers["Vary"], ab_test.response_header].compact.join(", ")
    end

    # HTML meta tag used to track the results of your experiment
    #
    # @return [String]
    def analytics_meta_tag
      '<meta name="govuk:ab-test" ' +
        'content="' + ab_test.meta_tag_name + ":" + variant_name + '" ' +
        'data-analytics-dimension="' + @dimension.to_s + '" ' +
        'data-allowed-variants="' + ab_test.allowed_variants.join(",") + '">'
    end
  end
end
