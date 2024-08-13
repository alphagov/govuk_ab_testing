# This class replicates the behaviour of a `ActionController::TestCase` to allow
# us to test the minitest helpers, in RSpec.
class FakeMinitestControllerTestCase
  def initialize
    @request = FakeRequestResponseObject.new
    @response = response
  end

  def assert(*); end

  def assert_equal(*); end

  def assert_select(*); end

  def assert_match(*); end

  def refute_nil(*); end

  def refute_equal(*); end

  def css_select(*)
    [
      FakeNokogiriElement.new,
    ]
  end

  def response
    FakeRequestResponseObject.new
  end

  class FakeNokogiriElement
    def attributes
      {
        "content" => FakeNokogiriAttr.new,
      }
    end
  end

  class FakeNokogiriAttr
    def value
      "example"
    end
  end

  class FakeRequestResponseObject
    def headers
      {}
    end

    def body
      "some content in the page body"
    end
  end
end
