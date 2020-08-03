module GovukAbTesting
  module RspecAssertions
    def assert_is_equal(expected:, actual:, error_message:)
      expect(actual).to eq(expected), error_message
    end

    def assert_contains_substring(string:, substring:, error_message:)
      expect(string).to include(substring), error_message
    end

    def assert_does_not_contain_substring(string:, substring:, error_message:)
      return if string.nil?

      expect(string).not_to include(substring), error_message
    end

    def assert_has_size(enumerable:, size:, error_message:)
      expect(enumerable.count).to eq(size), error_message
    end

    def assert_is_empty(enumerable:, error_message:)
      assert_has_size(enumerable, 0, error_message)
    end

    def assert_not_blank(string:, error_message:)
      expect(string).not_to be_nil, error_message
      expect(string.length).not_to eq(0), error_message
    end
  end
end
