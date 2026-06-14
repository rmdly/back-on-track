class CreateTaskTemplates < ActiveRecord::Migration[8.1]
  def change
    create_table :task_templates do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.string :category
      t.boolean :active, null: false, default: true
      t.string :frequency, null: false, default: "daily"
      t.integer :weekdays_mask, null: false, default: 0
      t.time :time_of_day
      t.integer :position, null: false, default: 0
      t.boolean :important, null: false, default: false

      t.timestamps
    end

    add_index :task_templates, [:user_id, :active]
    add_index :task_templates, [:user_id, :position]
  end
end
