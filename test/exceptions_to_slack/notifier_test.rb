require_relative '../test_helper'

class TestNotifier < MiniTest::Unit::TestCase
  TEAM = 'the-team'
  TOKEN = 'the-token'
  CHANNEL = 'the-channel'

  def setup
    @app = MiniTest::Mock.new

    @notifier = ExceptionsToSlack::Notifier.new(@app, {
      team: TEAM,
      token: TOKEN,
      channel: CHANNEL,
      ignore: /ignored/
    })
  end

  def test_exceptions_are_sent_to_slack
    def @app.call(env) raise ':boom:' end

    WebMock.stub_request(:post, 'https://the-team.slack.com/services/hooks/incoming-webhook?token=the-token').with(body: {
      payload: {
        text: '[RuntimeError] :boom:',
        channel: CHANNEL,
        username: 'Notifier'
      }.to_json
    })

    -> {@notifier.call([])}.must_raise RuntimeError
  end

  def test_exceptions_that_are_ignored
    def @app.call(env) raise 'should be ignored if raised' end
    # WebMock will raise if we try to send something to slack

    -> {@notifier.call([])}.must_raise RuntimeError
  end
end
