## 1.1.0

* Stop memoising meta tags so `with_variant` can be used multiple times in the
  same test cases.

## 1.0.0

* Pass in request headers instead of the actual request to RequestedVariant.
  This is a breaking change.
* Slit testing framework helpers from acceptance test frameworks. This means we
  can now use a combination of RSpec/Minitest and Capybara/ActiveSupport test
  cases.

## 0.2.0

* Include RSpec + Capybara helper class
* Test custom dimensions on all helper classes
