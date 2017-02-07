module GovukAbTesting
  module MinitestHelpers
    def with_variant(args)
      ab_test_name, variant = args.first

      ab_test = GovukAbTesting::AbTest.new(ab_test_name.to_s)

      previous_variant = @request.headers[ab_test.request_header]
      @request.headers[ab_test.request_header] = variant

      requested_variant = ab_test.requested_variant(@request)

      yield

      assert_equal ab_test.response_header, response.headers['Vary'], "You probably forgot to use `configure_response`"
      assert_meta_tag "govuk:ab-test", ab_test.meta_tag_name + ':' + requested_variant.variant_name, "You probably forgot to add the `analytics_meta_tag`"

      @request.headers[ab_test.request_header] = previous_variant
    end

  private

    def assert_meta_tag(name, content, message)
      assert_select "meta[name='#{name}'][content='#{content}']", 1, message
    end
  end
end
