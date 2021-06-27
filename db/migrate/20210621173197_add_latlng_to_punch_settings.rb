class AddLatlngToPunchSettings < ActiveRecord::Migration[6.1]
  def change
    add_column :punch_settings, :geo_latitude, :decimal, precision: 10, scale: 6, default: 0, null: false
    add_column :punch_settings, :geo_longitude, :decimal, precision: 10, scale: 6, default: 0, null: false
    add_column :punch_settings, :geo_status, :integer, default: 0, null: false
  end
end
