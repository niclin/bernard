# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_06_18_172042) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "punch_histories", force: :cascade do |t|
    t.text "response"
    t.integer "user_id", null: false
    t.integer "kind", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "punch_schedules", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "time_line", null: false
    t.date "date", null: false
    t.integer "perform_at_unixtime"
    t.integer "schedule_at_unixtime"
    t.integer "status", default: 0
    t.text "response"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "punch_settings", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "uid", null: false
    t.string "id_serial", null: false
    t.string "start_work_time", null: false
    t.integer "start_work_padding_percentage", default: 0, null: false
    t.string "end_work_time", null: false
    t.integer "end_work_padding_percentage", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.boolean "is_admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
