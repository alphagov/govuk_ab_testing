module GovukAbTesting
  module RspecCapybaraHelpers
    def with_variant(args)
      unless defined?(page)
        raise "The variable 'page' is not defined, are you using capybara?"
      end

      ab_test_name, variant = args.first
      dimension = args[:dimension]
      ab_test =
        GovukAbTesting::AbTest.new(ab_test_name.to_s, dimension: dimension)

      page.driver.header(ab_test.response_header, variant)

      yield

      expect(ab_test.response_header).to eq(page.response_headers['Vary'])

      unless args[:assert_meta_tag] == false
        content = [ab_test.meta_tag_name, variant].join(':')
        ab_test_metatag = page.find("meta[name='govuk:ab-test']", visible: :all)

        expect(ab_test_metatag['content']).to eq(content)

        if dimension.nil?
          expect(ab_test_metatag['data-analytics-dimension']).to_not be_nil
        else
          expect(ab_test_metatag['data-analytics-dimension']).to eq(dimension.to_s)
        end
      end
    end
  end
end
