module GovukAbTesting
  module AcceptanceTests
    class MetaTag
      attr_reader :content

      def initialize(content:)
        @content = content
      end

      def for_ab_test?(ab_test_name)
        content.match(/#{ab_test_name}/i)
      end
    end
  end
end
