class CreateMealIngredients < ActiveRecord::Migration[8.1]
  def change
    create_table :meal_ingredients do |t|
      t.references :meal, null: false, foreign_key: true
      t.references :shopping_item, null: true, foreign_key: true
      t.string :name, null: false
      t.decimal :quantity, precision: 8, scale: 2
      t.string :unit
      t.integer :position, null: false, default: 0

      t.timestamps
    end

    add_index :meal_ingredients, [:meal_id, :position]
  end
end
