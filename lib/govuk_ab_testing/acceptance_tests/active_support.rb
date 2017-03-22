module GovukAbTesting
  module AcceptanceTests
    class ActiveSupport
      attr_reader :request, :request_headers, :scope

      def initialize(scope)
        @request = scope.instance_variable_get(:@request)
        if @request.nil?
          raise "Couldn't find '@request' defined, are you using ActiveSupport test cases?"
        end
        @scope = scope
        @request_headers = {}
        @response = scope.instance_variable_get(:@response)
      end

      def set_header(name, value)
        request.headers[name] = value
        @request_headers[name] = value
      end

      def vary_header
        @response.headers['Vary']
      end

      def analytics_meta_tags_for_test(ab_test_name)
        analytics_meta_tags.select { |tag| tag.for_ab_test?(ab_test_name) }
      end

      def analytics_meta_tags
        tags = scope.css_select(ANALYTICS_META_TAG_SELECTOR)

        tags.map do |tag|
          MetaTag.new(
            content: tag.attributes['content'].value,
            dimension: tag.attributes['data-analytics-dimension'].value
          )
        end
      end
    end
  end
end
