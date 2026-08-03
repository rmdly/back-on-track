class CreateDailyPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_plans do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.text :notes

      t.timestamps
    end

    add_index :daily_plans, [ :user_id, :date ], unique: true
  end
end
