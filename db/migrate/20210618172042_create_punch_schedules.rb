class CreatePunchSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :punch_schedules do |t|
      t.integer :user_id, null: false
      t.string :time_line, limit: 2, null: false
      t.date :date, null: false
      t.datetime :perform_at
      t.integer :status, default: 0
      t.text :response

      t.timestamps
    end
  end
end
