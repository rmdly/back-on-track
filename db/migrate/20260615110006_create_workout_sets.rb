class CreateWorkoutSets < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_sets do |t|
      t.references :workout_exercise, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.decimal :weight, precision: 8, scale: 2
      t.integer :reps
      t.decimal :distance, precision: 8, scale: 2
      t.integer :duration_seconds
      t.decimal :rpe, precision: 3, scale: 1
      t.datetime :completed_at
      t.text :notes

      t.timestamps
    end

    add_index :workout_sets, [ :workout_exercise_id, :position ]
  end
end
