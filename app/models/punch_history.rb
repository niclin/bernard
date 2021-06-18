class PunchHistory < ApplicationRecord
  belongs_to :user

  enum kind: {
    AM: 0,
    PM: 1
  }
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
