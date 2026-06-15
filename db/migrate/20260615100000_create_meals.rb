class CreateMeals < ActiveRecord::Migration[8.1]
  def change
    create_table :meals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :meal_type, null: false, default: "dinner"
      t.text :description
      t.text :instructions
      t.integer :estimated_cost_cents
      t.integer :prep_time_minutes
      t.string :protein_level
      t.string :effort_level
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :meals, [:user_id, :active]
    add_index :meals, [:user_id, :name]
  end
end
