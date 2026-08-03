class CreateWorkoutTemplateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_template_exercises do |t|
      t.references :workout_template, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :position, null: false, default: 0
      t.integer :target_sets
      t.integer :target_reps
      t.decimal :target_weight, precision: 8, scale: 2
      t.text :notes

      t.timestamps
    end

    add_index :workout_template_exercises, [ :workout_template_id, :position ],
              name: "index_wte_on_template_and_position"
  end
end
