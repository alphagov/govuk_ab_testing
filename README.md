# GOV.UK A/B Testing

Gem to help with A/B testing on the GOV.UK platform.

## Technical documentation

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'govuk_ab_testing', '~> VERSION'
```

And then execute:

    $ bundle

### Usage

Before starting this, you'll need to

- get your cookie listed on [/help/cookies](https://www.gov.uk/help/cookies)
- configure the CDN [like we did for the Education Navigation test](https://github.com/alphagov/govuk-cdn-config/pull/17).
- configure Google Analytics (guidelines to follow)

To enable testing in the app, your Rails app needs:

1. Some piece of logic to be A/B tested
2. A HTML meta tag that will be used to measure the results
3. A response HTTP header that tells Fastly you're doing an A/B test

Let's say you have this controller:

```ruby
# app/controllers/party_controller.rb
class PartyController < ApplicationController
  def show
    ab_test = GovukAbTesting::AbTest.new("your_ab_test_name")
    @requested_variant = ab_test.requested_variant(request)
    @requested_variant.configure_response(response)

    if @requested_variant.variant_b?
      render "new_show_template_to_be_tested"
    else
      render "show"
    end
  end
end
```

Add this to your layouts, so that we have a meta tag that can be picked up
by the extension and analytics.

```html
<!-- application.html.erb -->
<head>
  <%= @requested_variant.analytics_meta_tag.html_safe %>
</head>
```

You'll be able to test the controller like this:

```ruby
# test/controllers/party_controller_test.rb
class PartyControllerTest < ActionController::TestCase
  include GovukAbTesting::MinitestHelpers

  should "show the user the B version" do
    with_variant your_ab_test_name: "B" do
      get :show

      assert_rendered "new_show_template_to_be_tested"
      assert_ab_test_rendered "example"
    end
  end
end
```

### Running the test suite

`bundle exec rake`

### Documentation

See [RubyDoc](http://www.rubydoc.info/gems/govuk_ab_testing) for some limited documentation.

To run a Yard server locally to preview documentation, run:

    $ bundle exec yard server --reload

## Licence

[MIT License](LICENCE.txt)
