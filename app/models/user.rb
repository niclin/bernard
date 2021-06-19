class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :punch_setting
  has_many :punch_schedules

  def alreday_punch_today?(time_line: "AM")
    punch_schedules.where(
      date: Date.today,
      time_line: time_line,
    ).where.not(perform_at_unixtime: nil).exists?
  end
end
