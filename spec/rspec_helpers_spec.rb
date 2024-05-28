require "spec_helper"
require "./spec/support/fake_capybara_page"

RSpec.describe GovukAbTesting::RspecHelpers do
  include GovukAbTesting::RspecHelpers

  def page
    @page ||= FakeCapybaraPage.new(:example, "B")
  end

  it "tests the behviour of with_variant" do
    GovukAbTesting.configure do |config|
      config.acceptance_test_framework = :capybara
    end

    object = double(call: true)
    expect(object).to receive(:call)

    with_variant example: "B" do
      object.call
    end
  end
end
