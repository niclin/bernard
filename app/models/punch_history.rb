class PunchHistory < ApplicationRecord
  belongs_to :user

  enum kind: {
    AM: 0,
    PM: 1
  }
end
