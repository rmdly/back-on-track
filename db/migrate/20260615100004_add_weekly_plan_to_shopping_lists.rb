class AddWeeklyPlanToShoppingLists < ActiveRecord::Migration[8.1]
  def change
    add_reference :shopping_lists, :weekly_plan, null: true, foreign_key: true
  end
end
