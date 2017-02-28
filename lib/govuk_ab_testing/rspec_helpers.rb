module GovukAbTesting
  module RspecHelpers
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

      vary_header_value = acceptance_test_framework.vary_header
      expect(ab_test.response_header).to eq(vary_header_value)

      unless args[:assert_meta_tag] == false
        content = [ab_test.meta_tag_name, requested_variant.variant_name].join(':')
        ab_test_metatags = acceptance_test_framework.analytics_meta_tags

        expect(ab_test_metatags.count).to eq(1)

        expect(acceptance_test_framework.content).to eq(content)
        dimension = acceptance_test_framework.dimension

        if dimension.nil?
          expect(dimension).to_not be_nil
        else
          expect(dimension).to eq(dimension.to_s)
        end
      end
    end
  end
end
