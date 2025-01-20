lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "govuk_ab_testing/version"

Gem::Specification.new do |spec|
  spec.name          = "govuk_ab_testing"
  spec.version       = GovukAbTesting::VERSION
  spec.authors       = ["GOV.UK Dev"]
  spec.email         = ["govuk-dev@digital.cabinet-office.gov.uk"]

  spec.summary       = "Gem to help with A/B testing on the GOV.UK platform"
  spec.description   = "Gem to help with A/B testing on the GOV.UK platform"
  spec.homepage      = "https://github.com/alphagov/govuk_ab_testing"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 3.1"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rubocop-govuk", "5.0.8"
  spec.add_development_dependency "yard"
end
