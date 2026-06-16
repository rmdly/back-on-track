class CreateWorkoutSessions < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workout_template, null: true, foreign_key: true
      # planned_workout_id is set later; no DB FK to avoid a circular reference
      # with planned_workouts.workout_session_id.
      t.references :planned_workout, null: true, index: true
      t.date :performed_on, null: false
      t.string :name
      t.text :notes
      t.datetime :started_at
      t.datetime :completed_at

      t.timestamps
    end

    add_index :workout_sessions, [:user_id, :performed_on]
  end
end
