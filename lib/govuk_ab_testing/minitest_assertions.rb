module GovukAbTesting
  module MinitestAssertions
    def assert_is_equal(expected:, actual:, error_message:)
      assert_equal(expected, actual, error_message)
    end

    def assert_contains_substring(string:, substring:, error_message:)
      assert_match(/#{substring}/, string, error_message)
    end

    def assert_does_not_contain_substring(string:, substring:, error_message:)
      refute_match(/#{substring}/, string, error_message)
    end

    def assert_has_size(enumerable:, size:, error_message:)
      assert_equal(size, enumerable.count, error_message)
    end

    def assert_is_empty(enumerable:, error_message:)
      assert_has_size(enumerable: enumerable, size: 0, error_message: error_message)
    end

    def assert_not_blank(string:, error_message:)
      refute_nil(string, error_message)
      refute_equal(string.length, 0, error_message)
    end
  end
end
