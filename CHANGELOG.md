## 2.1.0

* Refactor both RSpec and Minitest helpers to use the same Abstract helper
* Allow assertions on the Vary header for multiple concurrent A/B tests
* Fix a broken RSpec assertion
* Fix meta tag dimension checking

## 2.0.0

* **BREAKING CHANGE** `assert_response_not_modified_for_ab_test` now
  requires a parameter to indicate what A/B test we are referring to.
  This allows for multiple A/B tests to exist without letting the test
  cases fail in case they encounter a different A/B test in the Vary header;
* **BREAKING CHANGE** `assert_page_not_tracked_in_ab_test` now also
  requires a parameter to indicate what A/B test we are referring to.
  The reason is similar to the one mentioned above;
* New class introduced to represent a meta tag. This lets us query if a
  given meta tag belongs to a given A/B test.

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
