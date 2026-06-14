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

ActiveRecord::Schema[8.1].define(version: 2026_06_14_203122) do
  create_table "daily_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "date"], name: "index_daily_plans_on_user_id_and_date", unique: true
    t.index ["user_id"], name: "index_daily_plans_on_user_id"
  end

  create_table "daily_tasks", force: :cascade do |t|
    t.string "category"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.integer "daily_plan_id", null: false
    t.boolean "important", default: false, null: false
    t.text "notes"
    t.integer "position", default: 0, null: false
    t.string "skip_reason"
    t.datetime "skipped_at"
    t.string "source", default: "manual", null: false
    t.integer "task_template_id"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["daily_plan_id", "position"], name: "index_daily_tasks_on_daily_plan_id_and_position"
    t.index ["daily_plan_id", "task_template_id"], name: "index_daily_tasks_unique_template_per_plan", unique: true, where: "task_template_id IS NOT NULL"
    t.index ["daily_plan_id"], name: "index_daily_tasks_on_daily_plan_id"
    t.index ["task_template_id"], name: "index_daily_tasks_on_task_template_id"
    t.index ["user_id"], name: "index_daily_tasks_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "task_templates", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "frequency", default: "daily", null: false
    t.boolean "important", default: false, null: false
    t.integer "position", default: 0, null: false
    t.time "time_of_day"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "weekdays_mask", default: 0, null: false
    t.index ["user_id", "active"], name: "index_task_templates_on_user_id_and_active"
    t.index ["user_id", "position"], name: "index_task_templates_on_user_id_and_position"
    t.index ["user_id"], name: "index_task_templates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.string "time_zone", default: "UTC", null: false
    t.datetime "updated_at", null: false
    t.string "week_starts_on", default: "monday", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "daily_plans", "users"
  add_foreign_key "daily_tasks", "daily_plans"
  add_foreign_key "daily_tasks", "task_templates"
  add_foreign_key "daily_tasks", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "task_templates", "users"
end
