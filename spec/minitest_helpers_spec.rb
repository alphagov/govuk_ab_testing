require "spec_helper"

class AnExampleMiniTestCase < FakeMinitestControllerTestCase
  include GovukAbTesting::MinitestHelpers

  def test_name_of_a_test
    with_variant(example: 'B') do
      # We're testing the behaviour of `with_variant` here.
    end
  end
end

describe GovukAbTesting::MinitestHelpers do
  it "runs without errors" do
    AnExampleMiniTestCase.new.test_name_of_a_test
  end
end
