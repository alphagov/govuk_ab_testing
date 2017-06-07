require 'spec_helper'

describe GovukAbTesting::AcceptanceTests::Capybara do
  let(:capybara_acceptance_test) do
    driver = double(options: {}, header: true)
    page = double('Capybara::Session', driver: driver)
    scope = double(page: page)

    described_class.new(scope)
  end

  it 'is possible to set multiple headers' do
    capybara_acceptance_test.set_header('ABTest-1', 'A')
    capybara_acceptance_test.set_header('ABTest-2', 'B')

    request_headers = capybara_acceptance_test.request.driver.options[:headers]

    expect(request_headers['ABTest-1']).to eq('A')
    expect(request_headers['ABTest-2']).to eq('B')
  end
end
