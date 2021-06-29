class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :punch_setting
  has_many :punch_schedules
  after_create :send_welcome_notify

  def alreday_punch_today?(time_line: "AM")
    punch_schedules.where(
      date: Date.today,
      time_line: time_line,
    ).where.not(perform_at_unixtime: nil).exists?
  end

  private

  def send_welcome_notify
    text = ""
    attachments = [{
       "type": "mrkdwn",
       "color": SLACK_COLOR.public_send("success"),
       "text": "*狂暴的歡愉必將有著狂暴的結局*\n嗨 `#{self.email}` 歡迎來到西部世界!",
       "footer": "WestWorld(1973)",
       "ts": Time.zone.now.to_i
    }]

    slack_system_bot = SlackBot.new(channel: WEST_WORLD, username: "Bernard Bot")
    slack_system_bot.say(text, attachments)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  is_admin               :boolean          default(FALSE)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
