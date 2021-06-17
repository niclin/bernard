class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :punch_setting
  has_many :punch_histories

  def alreday_punch_today?(time_line: "AM")
    punch_histories.public_send(time_line).where(created_at: Time.zone.today.beginning_of_day..Time.zone.today.end_of_day).exists?
  end
end
