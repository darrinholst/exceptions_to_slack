require_relative '../test_helper'

class TestNotifier < MiniTest::Unit::TestCase
  URL = 'https://the.url.com'
  CHANNEL = 'the-channel'

  def setup
    @app = MiniTest::Mock.new

    @notifier = ExceptionsToSlack::Notifier.new(@app, {
      url: URL,
      channel: CHANNEL,
      ignore: /ignored/
    })
  end

  def test_exceptions_are_sent_to_slack
    def @app.call(env) raise ':boom:' end

    WebMock.stub_request(:post, 'https://the.url.com').with do |request|
      form = URI.decode_www_form(request.body)

      assert_equal 1, form.size
      assert_equal 2, form[0].size
      assert_equal 'payload', form[0][0]

      payload = JSON.parse(form[0][1])
      assert_equal '[RuntimeError] :boom:', payload['text']
      assert_equal CHANNEL, payload['channel']
      assert_equal 'Notifier', payload['username']
      assert !payload['attachments'][0]['text'].empty?

      true
    end

    -> {@notifier.call([])}.must_raise RuntimeError
  end

  def test_exceptions_that_are_ignored
    def @app.call(env) raise 'should be ignored if raised' end
    # WebMock will raise if we try to send something to slack

    -> {@notifier.call([])}.must_raise RuntimeError
  end
end
