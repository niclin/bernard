class PunchSchedule < ApplicationRecord
  belongs_to :user

  enum time_line: {
    AM: 0,
    PM: 1
  }
  enum status: {
    pending: 0,
    successed: 1,
    failed: 2,
    cancel: 3
  }

  scope :this_month, -> { where("perform_at_unixtime > ? AND perform_at_unixtime <= ?", Time.current.beginning_of_month.to_i, Time.current.end_of_month.to_i) }
  scope :month_at, ->(month) { where("perform_at_unixtime > ? AND perform_at_unixtime <= ?", Time.new(Time.current.year, month).beginning_of_month.to_i, Time.new(Time.current.year, month).end_of_month.to_i) }
end

# == Schema Information
#
# Table name: punch_schedules
#
#  id                   :bigint           not null, primary key
#  date                 :date             not null
#  perform_at_unixtime  :integer
#  response             :text
#  schedule_at_unixtime :integer
#  status               :integer          default("pending")
#  time_line            :integer          not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer          not null
#
