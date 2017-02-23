module GovukAbTesting
  module MinitestHelpers
    def with_variant(args)
      ab_test_name, variant = args.first
      dimension = args[:dimension]

      ab_test =
        GovukAbTesting::AbTest.new(ab_test_name.to_s, dimension: dimension)

      @request.headers[ab_test.request_header] = variant
      requested_variant = ab_test.requested_variant(@request)

      yield

      assert_match ab_test.response_header, response.headers['Vary'],
        "You probably forgot to use `configure_response`"

      unless args[:assert_meta_tag] == false
        expected_content =
          ab_test.meta_tag_name + ':' + requested_variant.variant_name
        message = "You probably forgot to add the `analytics_meta_tag` to the views"
        meta_tags = css_select("meta[name='govuk:ab-test']")

        assert_equal(1, meta_tags.count, message)

        meta_tag = meta_tags.first
        content_value = meta_tag.attributes['content'].value
        dimension_value = meta_tag.attributes['data-analytics-dimension'].value

        assert_equal(
          expected_content,
          content_value,
          "Meta tag's content doesn't match."
        )

        if dimension.nil?
          assert(dimension_value, "No custom dimension number found")
        else
          assert_equal(
            dimension.to_s,
            dimension_value,
            "The custom dimension found in meta tag doesn't match"
          )
        end
      end
    end

    def setup_ab_variant(ab_test_name, variant, dimension = 300)
      ab_test = GovukAbTesting::AbTest.new(ab_test_name, dimension: dimension)

      @request.headers[ab_test.request_header] = variant
    end

    def assert_response_not_modified_for_ab_test
      assert_nil response.headers['Vary'],
        "`Vary` header is being added to a page which is outside of the A/B test"

      assert_select "meta[name='govuk:ab-test']", false
    end
  end
end
