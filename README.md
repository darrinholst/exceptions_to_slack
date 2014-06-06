# ExceptionsToSlack

Sends exceptions to Slack

## Installation

Add this line to your application's Gemfile:

    gem 'exceptions_to_slack'

## Usage

Rails 3: add as rack middleware to `application.rb'

```ruby
config.middleware.use ExceptionsToSlack::Notifier,
    team: 'your-team-name',                        # required
    token: 'your-api-token',                       # required, https://my.slack.com/services/new/incoming-webhook
    channel: '#general',                           # required
    user: 'Exception Notifier',                    # optional, defaults to Notifier
    ignore: /Foo/,                                 # optional pattern for exceptions not to be sent
    additional_parameters: {icon_emoji: ':ghost:'} # optional parameters to send to slack
```

