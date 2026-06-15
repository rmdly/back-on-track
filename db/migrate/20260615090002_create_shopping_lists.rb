class CreateShoppingLists < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_lists do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: true, foreign_key: true
      # weekly_plan_id is added in Phase 3 when WeeklyPlan exists.
      t.string :name, null: false
      t.date :planned_on
      t.date :starts_on
      t.date :ends_on
      t.integer :budget_cents
      t.string :status, null: false, default: "draft"
      t.text :notes
      t.boolean :show_quantity, null: false, default: true
      t.boolean :show_unit, null: false, default: true
      t.boolean :show_price, null: false, default: true
      t.boolean :show_store, null: false, default: true

      t.timestamps
    end

    add_index :shopping_lists, [:user_id, :status]
  end
end
