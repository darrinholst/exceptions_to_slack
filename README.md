# ExceptionsToSlack

Sends exceptions to Slack

## Installation

Add this line to your application's Gemfile:

    gem 'exceptions_to_slack'

## Usage

Rails 3: add as rack middleware to `application.rb'

    config.middleware.use ExceptionsToSlack::Notifier,
        :team => "YOUR TEAM",
        :token => "YOUR TOKEN",
        :channel => "YOUR CHANNEL",
        :user => "USER MESSAGE WILL COME FROM"

