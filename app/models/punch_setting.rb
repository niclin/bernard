class PunchSetting < ApplicationRecord
  belongs_to :user

  enum status: {
    disable: 0,
    enable: 1
  }
end
