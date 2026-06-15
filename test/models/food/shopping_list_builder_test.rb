require "test_helper"

module Food
  class ShoppingListBuilderTest < ActiveSupport::TestCase
    setup do
      @user = users(:one)
      @plan = WeeklyPlan.current_for(@user, Date.new(2026, 6, 17))
      @rice = @user.shopping_items.create!(name: "Rice", default_unit: "g", estimated_unit_price_cents: 175)
    end

    def plan_meal(meal)
      @plan.planned_meals.create!(user: @user, meal: meal, planned_on: @plan.starts_on,
                                  meal_type: :dinner, name: meal.name)
    end

    test "groups matching ingredients by name and unit, summing quantity" do
      meal1 = @user.meals.create!(name: "Chicken rice", meal_type: :dinner)
      meal1.meal_ingredients.create!(name: "Rice", quantity: 100, unit: "g", shopping_item: @rice)
      meal2 = @user.meals.create!(name: "Mince rice", meal_type: :dinner)
      meal2.meal_ingredients.create!(name: "Rice", quantity: 50, unit: "g", shopping_item: @rice)

      plan_meal(meal1)
      plan_meal(meal2)

      list = ShoppingListBuilder.new(@plan).build!
      rice_items = list.shopping_list_items.where(name: "Rice").to_a

      assert_equal 1, rice_items.size
      assert_equal 150, rice_items.first.quantity
      assert_equal "g", rice_items.first.unit
      assert_equal 175, rice_items.first.estimated_unit_price_cents
    end

    test "keeps different units on separate rows" do
      meal = @user.meals.create!(name: "Mixed", meal_type: :dinner)
      meal.meal_ingredients.create!(name: "Rice", quantity: 100, unit: "g")
      meal.meal_ingredients.create!(name: "Rice", quantity: 1, unit: "cup")
      plan_meal(meal)

      list = ShoppingListBuilder.new(@plan).build!
      assert_equal 2, list.shopping_list_items.where(name: "Rice").count
    end

    test "links the generated list to the weekly plan and ignores meals without ingredients" do
      ad_hoc = @plan.planned_meals.create!(user: @user, planned_on: @plan.starts_on,
                                           meal_type: :lunch, name: "Leftovers")
      assert ad_hoc.persisted?

      list = ShoppingListBuilder.new(@plan).build!
      assert_equal @plan, list.weekly_plan
      assert_equal 0, list.shopping_list_items.count
    end

    test "rebuilding does not duplicate items" do
      meal = @user.meals.create!(name: "Chicken rice", meal_type: :dinner)
      meal.meal_ingredients.create!(name: "Rice", quantity: 100, unit: "g")
      plan_meal(meal)

      first = ShoppingListBuilder.new(@plan).build!
      second = ShoppingListBuilder.new(@plan).build!

      assert_equal first.id, second.id
      assert_equal 1, second.shopping_list_items.count
    end
  end
end
