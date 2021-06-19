class DropPunchHistory < ActiveRecord::Migration[6.1]
  def change
    drop_table :punch_histories
  end
end
