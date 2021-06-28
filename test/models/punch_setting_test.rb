require "test_helper"

class PunchSettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
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
