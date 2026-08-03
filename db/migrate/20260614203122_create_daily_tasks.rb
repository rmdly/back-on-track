class CreateDailyTasks < ActiveRecord::Migration[8.1]
  def change
    create_table :daily_tasks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :daily_plan, null: false, foreign_key: true
      t.references :task_template, null: true, foreign_key: true
      t.string :title, null: false
      t.text :notes
      t.string :category
      t.string :source, null: false, default: "manual"
      t.integer :position, null: false, default: 0
      t.boolean :important, null: false, default: false
      t.datetime :completed_at
      t.datetime :skipped_at
      t.string :skip_reason

      t.timestamps
    end

    add_index :daily_tasks, [ :daily_plan_id, :position ]
    # A template should generate at most one task per day.
    add_index :daily_tasks, [ :daily_plan_id, :task_template_id ], unique: true,
              where: "task_template_id IS NOT NULL", name: "index_daily_tasks_unique_template_per_plan"
  end
end
