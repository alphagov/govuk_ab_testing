$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "govuk_ab_testing"

# This class replicates the behaviour of a `ActionController::TestCase` to allow
# us to test the minitest helpers, in RSpec.
class FakeMinitestControllerTestCase
  def initialize
    @request = FakeRequestResponseObject.new
  end

  def assert_equal(*)
  end

  def assert_select(*)
  end

  def response
    FakeRequestResponseObject.new
  end

  class FakeRequestResponseObject
    def headers
      {}
    end
  end
end
