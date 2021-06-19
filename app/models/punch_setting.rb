class PunchSetting < ApplicationRecord
  belongs_to :user

  enum status: {
    disable: 0,
    enable: 1
  }

  def mask_id_serial
    id_serial.dup.tap { |m| m[2..4] = "***" }
  end
end

# == Schema Information
#
# Table name: punch_settings
#
#  id                            :bigint           not null, primary key
#  end_work_padding_percentage   :integer          default(0), not null
#  end_work_time                 :string           not null
#  id_serial                     :string           not null
#  start_work_padding_percentage :integer          default(0), not null
#  start_work_time               :string           not null
#  status                        :integer          default("disable"), not null
#  uid                           :string           not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id                       :integer          not null
#
