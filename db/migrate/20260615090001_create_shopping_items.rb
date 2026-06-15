class CreateShoppingItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :store, null: true, foreign_key: true
      t.string :name, null: false
      t.string :category
      t.decimal :default_quantity, precision: 8, scale: 2
      t.string :default_unit
      t.integer :estimated_unit_price_cents
      t.text :notes
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :shopping_items, [:user_id, :active]
    add_index :shopping_items, [:user_id, :name]
  end
end
