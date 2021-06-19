class CreatePunchSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :punch_schedules do |t|
      t.integer :user_id, null: false
      t.integer :time_line, null: false
      t.date :date, null: false
      t.integer :perform_at_unixtime
      t.integer :schedule_at_unixtime
      t.integer :status, default: 0
      t.text :response

      t.timestamps
    end
  end
end
