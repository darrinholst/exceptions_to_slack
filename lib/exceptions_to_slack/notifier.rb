require 'slack-notifier'

module ExceptionsToSlack
  class Notifier
    def initialize(app, options = {})
      @app = app
      @notifier = Slack::Notifier.new(url(options))
      @notifier.channel = options[:channel] || raise("Channel is required")
      @notifier.username = options[:user] || "Notifier"
      @ignore = options[:ignore]
      @additional_parameters = options[:additional_parameters] || {}
    end

    def call(env)
      @app.call(env)
    rescue Exception => exception
      send_to_slack(exception) unless @ignore && @ignore.match(exception.to_s)
      raise exception
    end

    private

    def send_to_slack(exception)
      begin
        @notifier.ping message_for(exception), @additional_parameters.merge({attachments: [attachment_for(exception)]})
      rescue => slack_exception
        $stderr.puts "\nWARN: Unable to send message to Slack: #{slack_exception}\n"
      end
    end

    def url(options)
      options[:url] || raise("URL is required")
    end

    def message_for(exception)
      "[#{exception.class}] #{exception}"
    end

    def attachment_for(exception)
      {
        fallback: 'Stack trace',
        color: 'warning',
        text: exception.backtrace.join("\n")
      }
    end
  end
end

