# Slack bot integration
# Doc: https://api.slack.com/bot-users

require "rest-client"

class SlackBot
  class ResponseError < StandardError; end

  def initialize(channel:, username: "slack_bot")
    @channel = channel
    @username = username
  end

  def say(text, attachments = nil)
    if true
      response = RestClient.post "https://slack.com/api/chat.postMessage", {
        "token": Rails.application.credentials.slack[:token],
        "channel": @channel,
        "username": @username,
        "text": text,
        "attachments": attachments.to_json
      }

      response_body = JSON.parse(response.body)

      if response_body["ok"] == false
        raise ResponseError, response_body["error"]
      end
    else
      response = RestClient.post SLACKBOMBZONE_WEBHOOK_URL, {
        "username": @username + " (#{Rails.env})",
        "text": text,
        "attachments": attachments
      }.to_json, { content_type: :json, accept: :json }
    end
  end
end
