class CreatePlannedMeals < ActiveRecord::Migration[8.1]
  def change
    create_table :planned_meals do |t|
      t.references :user, null: false, foreign_key: true
      t.references :weekly_plan, null: false, foreign_key: true
      t.references :meal, null: true, foreign_key: true
      t.date :planned_on, null: false
      t.string :meal_type, null: false, default: "dinner"
      t.string :name, null: false
      t.text :notes

      t.timestamps
    end

    add_index :planned_meals, [:weekly_plan_id, :planned_on]
  end
end
