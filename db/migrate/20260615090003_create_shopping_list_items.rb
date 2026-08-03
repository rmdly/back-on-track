class CreateShoppingListItems < ActiveRecord::Migration[8.1]
  def change
    create_table :shopping_list_items do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shopping_list, null: false, foreign_key: true
      t.references :shopping_item, null: true, foreign_key: true
      t.references :store, null: true, foreign_key: true
      t.string :name, null: false
      t.decimal :quantity, precision: 8, scale: 2
      t.string :unit
      t.integer :estimated_unit_price_cents
      t.integer :position, null: false, default: 0
      t.text :notes
      t.datetime :bought_at

      t.timestamps
    end

    add_index :shopping_list_items, [ :shopping_list_id, :position ]
  end
end
