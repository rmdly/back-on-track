class CreateWeeklyPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :weekly_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :starts_on, null: false
      t.date :ends_on, null: false
      t.integer :food_budget_cents
      t.text :notes

      t.timestamps
    end

    add_index :weekly_plans, [ :user_id, :starts_on ], unique: true
  end
end
