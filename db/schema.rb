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

ActiveRecord::Schema[8.1].define(version: 2026_06_15_110006) do
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

  create_table "exercises", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "default_unit"
    t.string "equipment"
    t.string "exercise_type", default: "strength", null: false
    t.string "muscle_group"
    t.string "name", null: false
    t.text "notes"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "active"], name: "index_exercises_on_user_id_and_active"
    t.index ["user_id", "name"], name: "index_exercises_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_exercises_on_user_id"
  end

  create_table "meal_ingredients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "meal_id", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.decimal "quantity", precision: 8, scale: 2
    t.integer "shopping_item_id"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.index ["meal_id", "position"], name: "index_meal_ingredients_on_meal_id_and_position"
    t.index ["meal_id"], name: "index_meal_ingredients_on_meal_id"
    t.index ["shopping_item_id"], name: "index_meal_ingredients_on_shopping_item_id"
  end

  create_table "meals", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "effort_level"
    t.integer "estimated_cost_cents"
    t.text "instructions"
    t.string "meal_type", default: "dinner", null: false
    t.string "name", null: false
    t.integer "prep_time_minutes"
    t.string "protein_level"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "active"], name: "index_meals_on_user_id_and_active"
    t.index ["user_id", "name"], name: "index_meals_on_user_id_and_name"
    t.index ["user_id"], name: "index_meals_on_user_id"
  end

  create_table "planned_meals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "meal_id"
    t.string "meal_type", default: "dinner", null: false
    t.string "name", null: false
    t.text "notes"
    t.date "planned_on", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "weekly_plan_id", null: false
    t.index ["meal_id"], name: "index_planned_meals_on_meal_id"
    t.index ["user_id"], name: "index_planned_meals_on_user_id"
    t.index ["weekly_plan_id", "planned_on"], name: "index_planned_meals_on_weekly_plan_id_and_planned_on"
    t.index ["weekly_plan_id"], name: "index_planned_meals_on_weekly_plan_id"
  end

  create_table "planned_workouts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.text "notes"
    t.date "planned_on", null: false
    t.string "status", default: "planned", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "weekly_plan_id"
    t.integer "workout_session_id"
    t.integer "workout_template_id"
    t.index ["user_id", "planned_on"], name: "index_planned_workouts_on_user_id_and_planned_on"
    t.index ["user_id"], name: "index_planned_workouts_on_user_id"
    t.index ["weekly_plan_id"], name: "index_planned_workouts_on_weekly_plan_id"
    t.index ["workout_session_id"], name: "index_planned_workouts_on_workout_session_id"
    t.index ["workout_template_id"], name: "index_planned_workouts_on_workout_template_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shopping_items", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.string "category"
    t.datetime "created_at", null: false
    t.decimal "default_quantity", precision: 8, scale: 2
    t.string "default_unit"
    t.integer "estimated_unit_price_cents"
    t.string "name", null: false
    t.text "notes"
    t.integer "store_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["store_id"], name: "index_shopping_items_on_store_id"
    t.index ["user_id", "active"], name: "index_shopping_items_on_user_id_and_active"
    t.index ["user_id", "name"], name: "index_shopping_items_on_user_id_and_name"
    t.index ["user_id"], name: "index_shopping_items_on_user_id"
  end

  create_table "shopping_list_items", force: :cascade do |t|
    t.datetime "bought_at"
    t.datetime "created_at", null: false
    t.integer "estimated_unit_price_cents"
    t.string "name", null: false
    t.text "notes"
    t.integer "position", default: 0, null: false
    t.decimal "quantity", precision: 8, scale: 2
    t.integer "shopping_item_id"
    t.integer "shopping_list_id", null: false
    t.integer "store_id"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["shopping_item_id"], name: "index_shopping_list_items_on_shopping_item_id"
    t.index ["shopping_list_id", "position"], name: "index_shopping_list_items_on_shopping_list_id_and_position"
    t.index ["shopping_list_id"], name: "index_shopping_list_items_on_shopping_list_id"
    t.index ["store_id"], name: "index_shopping_list_items_on_store_id"
    t.index ["user_id"], name: "index_shopping_list_items_on_user_id"
  end

  create_table "shopping_lists", force: :cascade do |t|
    t.integer "budget_cents"
    t.datetime "created_at", null: false
    t.date "ends_on"
    t.string "name", null: false
    t.text "notes"
    t.date "planned_on"
    t.boolean "show_price", default: true, null: false
    t.boolean "show_quantity", default: true, null: false
    t.boolean "show_store", default: true, null: false
    t.boolean "show_unit", default: true, null: false
    t.date "starts_on"
    t.string "status", default: "draft", null: false
    t.integer "store_id"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "weekly_plan_id"
    t.index ["store_id"], name: "index_shopping_lists_on_store_id"
    t.index ["user_id", "status"], name: "index_shopping_lists_on_user_id_and_status"
    t.index ["user_id"], name: "index_shopping_lists_on_user_id"
    t.index ["weekly_plan_id"], name: "index_shopping_lists_on_weekly_plan_id"
  end

  create_table "stores", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "name"], name: "index_stores_on_user_id_and_name", unique: true
    t.index ["user_id", "position"], name: "index_stores_on_user_id_and_position"
    t.index ["user_id"], name: "index_stores_on_user_id"
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

  create_table "weekly_plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "ends_on", null: false
    t.integer "food_budget_cents"
    t.text "notes"
    t.date "starts_on", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "starts_on"], name: "index_weekly_plans_on_user_id_and_starts_on", unique: true
    t.index ["user_id"], name: "index_weekly_plans_on_user_id"
  end

  create_table "workout_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "exercise_id", null: false
    t.text "notes"
    t.integer "position", default: 0, null: false
    t.datetime "updated_at", null: false
    t.integer "workout_session_id", null: false
    t.index ["exercise_id"], name: "index_workout_exercises_on_exercise_id"
    t.index ["workout_session_id", "position"], name: "index_workout_exercises_on_session_and_position"
    t.index ["workout_session_id"], name: "index_workout_exercises_on_workout_session_id"
  end

  create_table "workout_sessions", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "name"
    t.text "notes"
    t.date "performed_on", null: false
    t.integer "planned_workout_id"
    t.datetime "started_at"
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "workout_template_id"
    t.index ["planned_workout_id"], name: "index_workout_sessions_on_planned_workout_id"
    t.index ["user_id", "performed_on"], name: "index_workout_sessions_on_user_id_and_performed_on"
    t.index ["user_id"], name: "index_workout_sessions_on_user_id"
    t.index ["workout_template_id"], name: "index_workout_sessions_on_workout_template_id"
  end

  create_table "workout_sets", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.decimal "distance", precision: 8, scale: 2
    t.integer "duration_seconds"
    t.text "notes"
    t.integer "position", default: 0, null: false
    t.integer "reps"
    t.decimal "rpe", precision: 3, scale: 1
    t.datetime "updated_at", null: false
    t.decimal "weight", precision: 8, scale: 2
    t.integer "workout_exercise_id", null: false
    t.index ["workout_exercise_id", "position"], name: "index_workout_sets_on_workout_exercise_id_and_position"
    t.index ["workout_exercise_id"], name: "index_workout_sets_on_workout_exercise_id"
  end

  create_table "workout_template_exercises", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "exercise_id", null: false
    t.text "notes"
    t.integer "position", default: 0, null: false
    t.integer "target_reps"
    t.integer "target_sets"
    t.decimal "target_weight", precision: 8, scale: 2
    t.datetime "updated_at", null: false
    t.integer "workout_template_id", null: false
    t.index ["exercise_id"], name: "index_workout_template_exercises_on_exercise_id"
    t.index ["workout_template_id", "position"], name: "index_wte_on_template_and_position"
    t.index ["workout_template_id"], name: "index_workout_template_exercises_on_workout_template_id"
  end

  create_table "workout_templates", force: :cascade do |t|
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "active"], name: "index_workout_templates_on_user_id_and_active"
    t.index ["user_id"], name: "index_workout_templates_on_user_id"
  end

  add_foreign_key "daily_plans", "users"
  add_foreign_key "daily_tasks", "daily_plans"
  add_foreign_key "daily_tasks", "task_templates"
  add_foreign_key "daily_tasks", "users"
  add_foreign_key "exercises", "users"
  add_foreign_key "meal_ingredients", "meals"
  add_foreign_key "meal_ingredients", "shopping_items"
  add_foreign_key "meals", "users"
  add_foreign_key "planned_meals", "meals"
  add_foreign_key "planned_meals", "users"
  add_foreign_key "planned_meals", "weekly_plans"
  add_foreign_key "planned_workouts", "users"
  add_foreign_key "planned_workouts", "weekly_plans"
  add_foreign_key "planned_workouts", "workout_sessions"
  add_foreign_key "planned_workouts", "workout_templates"
  add_foreign_key "sessions", "users"
  add_foreign_key "shopping_items", "stores"
  add_foreign_key "shopping_items", "users"
  add_foreign_key "shopping_list_items", "shopping_items"
  add_foreign_key "shopping_list_items", "shopping_lists"
  add_foreign_key "shopping_list_items", "stores"
  add_foreign_key "shopping_list_items", "users"
  add_foreign_key "shopping_lists", "stores"
  add_foreign_key "shopping_lists", "users"
  add_foreign_key "shopping_lists", "weekly_plans"
  add_foreign_key "stores", "users"
  add_foreign_key "task_templates", "users"
  add_foreign_key "weekly_plans", "users"
  add_foreign_key "workout_exercises", "exercises"
  add_foreign_key "workout_exercises", "workout_sessions"
  add_foreign_key "workout_sessions", "users"
  add_foreign_key "workout_sessions", "workout_templates"
  add_foreign_key "workout_sets", "workout_exercises"
  add_foreign_key "workout_template_exercises", "exercises"
  add_foreign_key "workout_template_exercises", "workout_templates"
  add_foreign_key "workout_templates", "users"
end
