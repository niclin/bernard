class PunchHistory < ApplicationRecord
  belongs_to :user

  enum kind: {
    AM: 0,
    PM: 1
  }
  enum status: {
    pending: 0,
    successed: 1,
    failed: 2
  }
end