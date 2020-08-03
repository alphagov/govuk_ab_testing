class FakeCapybaraPage
  attr_reader :ab_test_name, :ab_test_variant, :dimension

  def initialize(ab_test_name, ab_test_variant, dimension)
    @ab_test_name = ab_test_name
    @ab_test_variant = ab_test_variant
    @dimension = dimension
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
      "data-analytics-dimension" => dimension.to_s,
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
