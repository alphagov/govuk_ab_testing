## 1.0.4

* Port the individual set-up and assertion steps from Minitest to RSpec

## 1.0.3

* Add more Minitest helpers with more fine-grained assertions

## 1.0.2

* Ensure `assert_response_not_modified_for_ab_test` test helper works with all
  test frameworks

## 1.0.1

* Stop memoising meta tags so `with_variant` can be used multiple times in the
  same test cases.

## 1.0.0

* Pass in request headers instead of the actual request to RequestedVariant.
  This is a breaking change.
* Split testing framework helpers from acceptance test frameworks. This means we
  can now use a combination of RSpec/Minitest and Capybara/ActiveSupport test
  cases.

## 0.2.0

* Include RSpec + Capybara helper class
* Test custom dimensions on all helper classes
