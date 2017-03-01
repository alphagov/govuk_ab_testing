module GovukAbTesting
  module AcceptanceTests
    class Capybara
      attr_reader :capybara_page, :request_headers

      def initialize(scope)
        unless scope.respond_to?(:page)
          raise "Page is not defined, are you using capybara?"
        end
        @capybara_page = scope.page
        @request_headers = {}
      end

      def request
        @capybara_page
      end

      def set_header(name, value)
        capybara_page.driver.options[:headers] = { name => value }
        capybara_page.driver.header(name, value)
        @request_headers[name] = value
      end

      def vary_header(*)
        capybara_page.response_headers['Vary']
      end

      def analytics_meta_tags
        @analytics_meta_tags ||=
          capybara_page.all(ANALYTICS_META_TAG_SELECTOR, visible: :all)
      end

      def analytics_meta_tag
        analytics_meta_tags.first
      end

      def content
        analytics_meta_tag['content']
      end

      def dimension
        analytics_meta_tag['data-analytics-dimension']
      end
    end
  end
end
