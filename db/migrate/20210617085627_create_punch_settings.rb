class CreatePunchSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :punch_settings do |t|
      t.integer :user_id, null: false
      t.string :uid, null: false
      t.string :password, null: false
      t.string :start_work_time, null: false
      t.integer :start_work_padding_percentage, default: 0, null: false
      t.string :end_work_time, null: false
      t.integer :end_work_padding_percentage, default: 0, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
