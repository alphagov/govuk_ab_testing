module GovukAbTesting
  module AcceptanceTests
    class ActiveSupport
      attr_reader :request_headers, :scope

      def initialize(scope)
        @scope = scope
        @request_headers = {}

        if request.nil?
          raise "Couldn't find '@request' defined, are you using ActiveSupport test cases?"
        end
      end

      def request
        @scope.instance_variable_get(:@request)
      end

      def response
        @scope.instance_variable_get(:@response)
      end

      def set_header(name, value)
        request.headers[name] = value
        @request_headers[name] = value
      end

      def vary_header
        response.headers["Vary"]
      end

      def analytics_meta_tags_for_test(ab_test_name)
        analytics_meta_tags.select { |tag| tag.for_ab_test?(ab_test_name) }
      end

      def analytics_meta_tags
        if scope.response.body.empty?
          raise "Cannot find response body. If this is an RSpec Rails test, " \
            "check that 'render_views' is being called."
        end

        tags = scope.css_select(ANALYTICS_META_TAG_SELECTOR)

        tags.map do |tag|
          MetaTag.new(
            content: tag.attributes["content"].value,
          )
        end
      end
    end
  end
end
