module Notifier
  module SlackNotifiable
    extend ActiveSupport::Concern

    included do
      include Sidekiq::Worker
      include Rails.application.routes.url_helpers
    end

    def send_to_slack(channel, username, text, attachments)
      slack_system_bot = SlackBot.new(channel: channel, username: username)
      slack_system_bot.say(text, attachments)
    end
  end
end
