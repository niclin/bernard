# Slack bot integration
# Doc: https://api.slack.com/bot-users

require "rest-client"

class SlackBot
  class ResponseError < StandardError; end

  def initialize(username: "slack_bot")
    @username = username
  end

  def say(text, attachments = nil)
      response = RestClient.post SLACK_WEBHOOK_URL, {
        "username": @username,
        "text": text,
        "attachments": attachments
      }.to_json, { content_type: :json, accept: :json }
  end
end
