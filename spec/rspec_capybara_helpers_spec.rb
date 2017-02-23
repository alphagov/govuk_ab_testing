require "spec_helper"
require './spec/support/fake_capybara_page'

RSpec.describe GovukAbTesting::RspecCapybaraHelpers do
  include GovukAbTesting::RspecCapybaraHelpers

  def page
    @page ||= FakeCapybaraPage.new(:example, 'B', 100)
  end

  it 'tests the behviour of with_variant' do
    object = double(call: true)
    expect(object).to receive(:call)

    with_variant example: 'B' do
      object.call
    end
  end
end
