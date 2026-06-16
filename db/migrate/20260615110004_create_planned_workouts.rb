class CreatePlannedWorkouts < ActiveRecord::Migration[8.1]
  def change
    create_table :planned_workouts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :weekly_plan, null: true, foreign_key: true
      t.references :workout_template, null: true, foreign_key: true
      t.references :workout_session, null: true, foreign_key: true
      t.date :planned_on, null: false
      t.string :name, null: false
      t.string :status, null: false, default: "planned"
      t.text :notes

      t.timestamps
    end

    add_index :planned_workouts, [:user_id, :planned_on]
  end
end
