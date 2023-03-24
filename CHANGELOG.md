## Unreleased

* Drop support for Ruby 2.7.

## 2.4.2

* Updated gem dependencies and development ruby version to 2.6.6
* Fixed new rubocop violations

## 2.4.1

* Add extra validation to ActiveSupport assertions to help debug test failures.
  In order to make assertions about the `meta` tags, the view must be rendered
  in the test. RSpec Rails tests do not do this by default, so you need to call
  `render_views` explicitly. Without this check, tests fail with a cryptic error
  message "undefined method 'document' for nil:NilClass".

## 2.4.0

* Add two new optional parameters to `GovukAbTesting::AbTest`:
  `allowed_variants` and `control_variant`. These allow us to override the
  traditional naming of the A/B tests and also setup a multivariate test if
  needed.
* Add new method to `RequestedVariant` to query if a user is in a given variant.
  The method is `variant?(name)`, where `name` is the name of the variant.
  This new method allows for generic variant names, which are useful when
  reusing A/B testing cookies/headers. If the cookie name and header name are
  generic, the variant value should provide details on what test is running.
* Add deprecation warnings to `variant_a?` and `variant_b?`, as they will be
  replaced by the method `variant?(name)`.

## 2.3.1

* Fix bug in order to allow us to set multiple headers (i.e. A/B tests) in a
  test using Capybara. This is important when running multiple A/B tests at
  once.

## 2.3.0

* Fix for Rails 5.0.2 - the Active Support acceptance tests used to memoize
  the `@request` and `@response` objects. This worked fine in Rails 4, but
  it looks like Rails 5 now points to a different object at some point during
  the request/response lifecycle, breaking the memoization. The fix removes
  this memoization and directly queries the scope for each `@request` or
  `@response`.

## 2.2.0

* Remove string interpolated parameter in error message of
* `assert_page_not_tracked_in_ab_test` which may potentially be nil.
* Add keyname parameters for `assert_has_size` call inside `assert_is_empty`.

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
