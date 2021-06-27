class PunchSetting < ApplicationRecord
  belongs_to :user

  validate :work_time_range

  enum status: {
    disable: 0,
    enable: 1
  }

  def mask_id_serial
    id_serial.dup.tap { |m| m[2..4] = "***" }
  end

  private

  def work_time_range
    work_time_range = Time.zone.strptime(end_work_time, '%H%M').to_i - Time.zone.strptime(start_work_time, '%H%M').to_i
    if work_time_range < 8.5.hours.to_i
      errors.add(:end_work_time, "時間區間要大於 8.5 小時，實際工時 7.5小時")
    end
  end
end

# == Schema Information
#
# Table name: punch_settings
#
#  id                            :bigint           not null, primary key
#  end_work_padding_percentage   :integer          default(0), not null
#  end_work_time                 :string           not null
#  geo_latitude                  :decimal(10, 6)   default(0.0), not null
#  geo_longitude                 :decimal(10, 6)   default(0.0), not null
#  geo_status                    :integer          default(0), not null
#  id_serial                     :string           not null
#  start_work_padding_percentage :integer          default(0), not null
#  start_work_time               :string           not null
#  status                        :integer          default("disable"), not null
#  uid                           :string           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :integer          not null
#
