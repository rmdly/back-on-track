class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.string :exercise_type, null: false, default: "strength"
      t.string :muscle_group
      t.string :equipment
      t.string :default_unit
      t.boolean :active, null: false, default: true
      t.text :notes

      t.timestamps
    end

    add_index :exercises, [:user_id, :name], unique: true
    add_index :exercises, [:user_id, :active]
  end
end
