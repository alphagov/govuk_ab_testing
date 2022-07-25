# GOV.UK A/B Testing

Gem to help with A/B testing on the GOV.UK platform.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'govuk_ab_testing', '~> VERSION'
```

And then execute:

    $ bundle

## Pre-requisites

Before starting this, you'll need to:

- [Read the documentation](https://docs.publishing.service.gov.uk/manual/ab-testing.html) for an overview on how a/b testing works on GOV.UK. 
- The cookie and header name in [govuk-cdn-config](https://github.com/alphagov/govuk-cdn-config/blob/master/ab_tests/ab_tests.yaml) must match the test name parameter that you pass to the Gem. The cookie name is case-sensitive.

## Usage

### Outline 

To enable testing in the app, your Rails app needs:

1. [Some piece of logic to be A/B tested](#1-example-ab-test-logic)
2. [A response HTTP header that tells Fastly you're doing an A/B test](#2-http-response-header-to-fastly)
3. [A HTML meta tag that will be used to measure the results, and which specifies
   the dimension to use in Google Analytics](#3-add-html-metatag-tags-to-your-layouts)

### 1. Example A/B test logic

Let's say you have this controller:

```ruby
# app/controllers/party_controller.rb
class PartyController < ApplicationController
  def show
    ab_test = GovukAbTesting::AbTest.new(
      "your_ab_test_name",
      dimension: 300,
      allowed_variants: ['NoChange', 'LongTitle', 'ShortTitle'],
      control_variant: 'NoChange'
    )
    @requested_variant = ab_test.requested_variant(request.headers)
    @requested_variant.configure_response(response)

    case true
    when @requested_variant.variant?('LongTitle')
      render "show_template_with_long_title"
    when @requested_variant.variant?('ShortTitle')
      render "show_template_with_short_title"
    else
      render "show"
    end
  end
end
```

In this example, we are running a multivariate test with 3 options being
tested: the existing version (control), and two title changes. The minimum
number of variants in any test should be two. 

### 2. HTTP response header to Fastly

The `configure_response` method used in the example in `step 1` sends the response header. The header helps Fastly to understand which variant was returned to the user and cache appropriately.

### 3. Add HTML metatag tags to your layouts

This is for the extension and analytics.

```html
<!-- application.html.erb -->
<head>
  <%= @requested_variant.analytics_meta_tag.html_safe %>
</head>
```

The analytics meta tag will include the allowed variants so the extension knows
which variants to suggest to the user.

## Running the test suite for the gem

`bundle exec rake`

## Acceptance testing

Start by defining which acceptance testing framework you will use. This gem
supports both Capybara and ActiveSupport. In order to configure it, add this to
your test helper file:

```
GovukAbTesting.configure do |config|
  config.acceptance_test_framework = :capybara # or :active_support
end
```

If we use capybara, the gem expects `page` to be defined in the scope of the
test cases. If we use ActiveSupport, the gem expects `@request` to be defined in
the scope of the test cases.

### Test helpers

#### RSpec

It is also possible to use `with_variant` and all the individual setup and
assertions steps in RSpec tests. Here is an example of a Capybara feature file:

```ruby
# spec/features/ab_testing_spec.rb
feature "Viewing a page with an A/B test" do
  include GovukAbTesting::RspecHelpers

  scenario "viewing the B version of the page" do
    with_variant your_ab_test_name: 'B' do
      visit root_path

      expect(page).to have_breadcrumbs
      expect(page).to have_beta_label
    end
  end
end
```

And here is an RSpec controller test:

```ruby
# spec/controllers/some_controller_spec.rb
describe SomeController, type :controller do
  include GovukAbTesting::RspecHelpers

  # RSpec doesn't render views for controller specs by default
  render_views

  it "should render the B version of the page" do
    with_variant your_ab_test_name: 'B' do
      get :index
    end
  end
end
```

As with the `minitest` version, you can also pass in the following options to
`with_variant`:

- `assert_meta_tag: false`
- `dimension: <number>`

#### Minitest

The most common usage of an A/B test is to serve two different variants of the
same page. In this situation, you can test the controller using `with_variant`.
It will configure the request and assert that the response is configured
correctly:

```ruby
# test/controllers/party_controller_test.rb
class PartyControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  should "show the user the B version" do
    with_variant your_ab_test_name: "B" do
      get :show

      # Optional assertions about page content of the B variant
    end
  end
end
```

Pass the `assert_meta_tag: false` option to skip assertions about the `meta`
tag, for example because the variant returns a redirect response rather than
returning an HTML page.

```ruby
# test/controllers/party_controller_test.rb
class PartyControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  should "redirect the user the B version" do
    with_variant your_ab_test_name: "B", assert_meta_tag: false do
      get :show

      assert_response 302
      assert_redirected_to { controller: "other_controller", action: "show" }
    end
  end
end
```

To test the negative case in which a page is unaffected by the A/B test:

```ruby
# test/controllers/party_controller_test.rb
class PartyControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  should "show the original" do
    setup_ab_variant("your_ab_test_name", "B") # optionally pass in a analytics dimension as the third argument

    get :show

    assert_response_not_modified_for_ab_test("your_ab_test_name")
  end
end
```

There are some more fine-grained assertions which you can use to test a page
with A/B variants which should be cached separately, but which should be
excluded from the analytics:

```ruby
# test/controllers/party_controller_test.rb
class PartyControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  should "cache each variant but not add analytics" do
    setup_ab_variant("your_ab_test_name", "B")

    get :show

    assert_response_is_cached_by_variant("your_ab_test_name")
    assert_page_not_tracked_in_ab_test("your_ab_test_name")
  end
end
```

## API documentation

See [RubyDoc](http://www.rubydoc.info/gems/govuk_ab_testing) for documentation including all of the assertions for tests.

To run a Yard server locally to preview documentation, run:

    $ bundle exec yard server --reload

## Checking your A/B test in a browser

If you want to test this behaviour in a browser then you should use the
[GOV.UK Toolkit browser extension](https://github.com/alphagov/govuk-browser-extension).

This detects when you have a test running on a page and enables you to choose
between variants.

## Licence

[MIT License](LICENCE)
