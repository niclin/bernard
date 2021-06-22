module Notifier
  module SlackNotifiable
    extend ActiveSupport::Concern

    included do
      include Sidekiq::Worker
      include Rails.application.routes.url_helpers
    end

    def send_to_slack(username, text, attachments)
      slack_system_bot = SlackBot.new(username: username)
      slack_system_bot.say(text, attachments)
    end
  end
end
