module GovukAbTesting
  module AcceptanceTests
    class ActiveSupport
      attr_reader :request, :scope

      def initialize(scope)
        @request = scope.instance_variable_get(:@request)
        if @request.nil?
          raise "Couldn't find '@request' defined, are you using ActiveSupport test cases?"
        end
        @scope = scope
      end

      def set_header(name, value)
        request.headers[name] = value
      end

      def vary_header(response)
        response.headers['Vary']
      end

      def analytics_meta_tags
        @analytics_meta_tags ||= scope.css_select(ANALYTICS_META_TAG_SELECTOR)
      end

      def analytics_meta_tag
        analytics_meta_tags.first
      end

      def content
        analytics_meta_tag.attributes['content'].value
      end

      def dimension
        analytics_meta_tag.attributes['data-analytics-dimension'].value
      end
    end
  end
end
