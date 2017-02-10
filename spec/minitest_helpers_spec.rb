require "spec_helper"

class AnExampleMiniTestCase < FakeMinitestControllerTestCase
  include GovukAbTesting::MinitestHelpers

  def test_name_of_a_test
    with_variant(example: 'B', dimension: 50) do
      # We're testing the behaviour of `with_variant` here.
    end
  end

  def test_with_missing_dimension
    with_variant(example: 'B') do
    end
  end
end

describe GovukAbTesting::MinitestHelpers do
  it "runs without errors" do
    AnExampleMiniTestCase.new.test_name_of_a_test
  end

  it "rejects test with missing dimension parameter" do
    expect { AnExampleMiniTestCase.new.test_with_missing_dimension }.to raise_error(/dimension/)
  end
end
