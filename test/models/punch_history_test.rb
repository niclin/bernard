require "test_helper"

class PunchHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: punch_histories
#
#  id         :bigint           not null, primary key
#  kind       :integer          not null
#  response   :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer          not null
#
