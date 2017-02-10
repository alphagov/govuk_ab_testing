module GovukAbTesting
  module MinitestHelpers
    def with_variant(args)
      ab_test_name, variant = args.first

      ab_test = GovukAbTesting::AbTest.new(ab_test_name.to_s, dimension: args[:dimension])

      @request.headers[ab_test.request_header] = variant
      requested_variant = ab_test.requested_variant(@request)

      yield

      assert_match ab_test.response_header, response.headers['Vary'],
        "You probably forgot to use `configure_response`"

      unless args[:assert_meta_tag] == false
        content = ab_test.meta_tag_name + ':' + requested_variant.variant_name
        message = "You probably forgot to add the `analytics_meta_tag` to the views"
        assert_select "meta[name='govuk:ab-test'][content='#{content}']", 1, message
      end
    end

    def setup_ab_variant(ab_test_name, variant, dimension = 300)
      ab_test = GovukAbTesting::AbTest.new(ab_test_name, dimension: dimension)

      @request.headers[ab_test.request_header] = variant
    end

    def assert_unaffected_by_ab_test
      assert_nil response.headers['Vary'],
        "`Vary` header is being added to a page which is outside of the A/B test"

      assert_select "meta[name='govuk:ab-test']", false
    end
  end
end
