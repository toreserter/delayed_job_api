# DelayedJobApi

This gem is for creating an API gateway to your DJs to monitor them.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'delayed_job_api'
```

Then run `bundle install`

Next, you need to run the generator:
```ruby
rails generate delayed_job_api:install
```
The generator will install an initializer where you can set client_id and client_secret.

Also you need to add this line in your `routes.rb` file

```ruby
 mount DelayedJobApi::App, at: "/delayed_job"
```

## Usage



## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
