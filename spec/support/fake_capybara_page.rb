class FakeCapybaraPage
  attr_reader :ab_test_name, :ab_test_variant

  def initialize(ab_test_name, ab_test_variant)
    @ab_test_name = ab_test_name
    @ab_test_variant = ab_test_variant
  end

  def driver
    @driver ||= FakeCapybaraDriver.new
  end

  def response_headers
    {
      "Vary" => "GOVUK-ABTest-#{ab_test_name}",
    }
  end

  def all(*)
    [{
      "content" => "#{ab_test_name}:#{ab_test_variant}",
    }]
  end

  class FakeCapybaraDriver
    def initialize
      @headers = {}
    end

    def header(name, value)
      @headers[name] = value
    end

    def options
      @headers
    end
  end
end
