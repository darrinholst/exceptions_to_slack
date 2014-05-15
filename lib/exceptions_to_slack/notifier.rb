require 'slack-notifier'

module ExceptionsToSlack
  class Notifier
    def initialize(app, options = {})
      @app = app
      @notifier = Slack::Notifier.new(team(options), token(options))
      @notifier.channel = options[:channel] || raise("Channel is required")
      @notifier.username = options[:user] || "Notifier"
      @ignore = options[:ignore]
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      send_to_slack(exception) unless @ignore && @ignore.match(exception.to_s)
      raise exception
    end

    def send_to_slack(exception)
      begin
        @notifier.ping message_for(exception)
      rescue => slack_exception
        $stderr.puts "\nWARN: Unable to send message to Slack: #{slack_exception}\n"
      end
    end

    def message_for(exception)
      "[#{exception.class}] #{exception}"
    end

    private

    def team(options)
      options[:team] || raise("Team name is required")
    end

    def token(options)
      options[:token] || raise("Token is required")
    end
  end
end

