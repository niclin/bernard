class CreatePunchHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :punch_histories do |t|
      t.text :response
      t.integer :user_id, null: false
      t.integer :kind, null: false

      t.timestamps
    end
  end
end
