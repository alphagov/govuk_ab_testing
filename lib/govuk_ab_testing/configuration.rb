module GovukAbTesting
  class Configuration
    VALID_FRAMEWORKS = %i(capybara active_support).freeze
    attr_accessor :config, :acceptance_test_framework

    def initialize
      @config = {}
    end

    def acceptance_test_framework
      config[:acceptance_test_framework]
    end

    def acceptance_test_framework=(framework)
      unless VALID_FRAMEWORKS.include?(framework)
        raise "Invalid acceptance test framework '#{framework}'"
      end

      config[:acceptance_test_framework] = framework
      @framework_class = nil
    end

    def framework_class
      @framework_class ||= begin
        case config[:acceptance_test_framework]
        when :capybara
          then GovukAbTesting::AcceptanceTests::Capybara
        when :active_support
          then GovukAbTesting::AcceptanceTests::ActiveSupport
        else
          raise "Invalid framework #{acceptance_test_framework}"
        end
      end
    end
  end
end
