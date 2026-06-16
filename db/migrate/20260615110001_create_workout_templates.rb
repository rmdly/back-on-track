class CreateWorkoutTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :workout_templates, [:user_id, :active]
  end
end
