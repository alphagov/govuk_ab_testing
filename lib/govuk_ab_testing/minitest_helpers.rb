module GovukAbTesting
  module MinitestHelpers
    def acceptance_test_framework
      @acceptance_test_framework ||=
        GovukAbTesting.configuration.framework_class.new(self)
    end

    def with_variant(args)
      ab_test_name, variant = args.first
      dimension = args[:dimension]

      ab_test =
        GovukAbTesting::AbTest.new(ab_test_name.to_s, dimension: dimension)

      acceptance_test_framework.set_header(ab_test.request_header, variant)
      requested_variant = ab_test.requested_variant(acceptance_test_framework.request_headers)

      yield

      vary_header_value = acceptance_test_framework.vary_header(response)
      assert_match ab_test.response_header, vary_header_value,
        "You probably forgot to use `configure_response`"

      unless args[:assert_meta_tag] == false
        expected_content =
          ab_test.meta_tag_name + ':' + requested_variant.variant_name
        message = "You probably forgot to add the `analytics_meta_tag` to the views"
        meta_tags = acceptance_test_framework.analytics_meta_tags

        assert_equal(1, meta_tags.count, message)

        dimension_value = acceptance_test_framework.dimension

        assert_equal(
          expected_content,
          acceptance_test_framework.content,
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

      acceptance_test_framework.set_header(ab_test.request_header, variant)
    end

    def assert_response_not_modified_for_ab_test
      assert_nil acceptance_test_framework.vary_header(response),
        "`Vary` header is being added to a page which should not be modified by the A/B test"

      meta_tags = acceptance_test_framework.analytics_meta_tags
      assert_equal(0, meta_tags.count,
        "A/B meta tag is being added to a page which should not be modified by the A/B test")
    end
  end
end
