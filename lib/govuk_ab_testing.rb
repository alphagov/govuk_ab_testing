require 'govuk_ab_testing/version'
require 'govuk_ab_testing/configuration'
require 'govuk_ab_testing/requested_variant'
require 'govuk_ab_testing/ab_test'
require 'govuk_ab_testing/minitest_assertions'
require 'govuk_ab_testing/rspec_assertions'
require 'govuk_ab_testing/abstract_helpers'
require 'govuk_ab_testing/minitest_helpers'
require 'govuk_ab_testing/rspec_helpers'
require 'govuk_ab_testing/acceptance_tests/meta_tag'
require 'govuk_ab_testing/acceptance_tests/capybara'
require 'govuk_ab_testing/acceptance_tests/active_support'

module GovukAbTesting
  ANALYTICS_META_TAG_SELECTOR = "meta[name='govuk:ab-test']".freeze

  def self.configuration
    @configuration ||= GovukAbTesting::Configuration.new
  end

  def self.configure
    yield configuration if block_given?
  end
end
