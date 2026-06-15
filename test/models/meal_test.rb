require "test_helper"

class MealTest < ActiveSupport::TestCase
  setup { @user = users(:one) }

  test "requires a name and meal_type" do
    meal = @user.meals.new(name: nil, meal_type: nil)
    assert_not meal.valid?
  end

  test "cheap? is true at or below the threshold" do
    assert @user.meals.new(name: "x", estimated_cost_cents: 250).cheap?
    assert_not @user.meals.new(name: "x", estimated_cost_cents: 900).cheap?
    assert_not @user.meals.new(name: "x", estimated_cost_cents: nil).cheap?
  end

  test "high_protein? reflects the protein level" do
    assert @user.meals.new(name: "x", protein_level: :high).high_protein?
    assert_not @user.meals.new(name: "x", protein_level: :low).high_protein?
  end

  test "quick? is true at or below the prep threshold" do
    assert @user.meals.new(name: "x", prep_time_minutes: 10).quick?
    assert_not @user.meals.new(name: "x", prep_time_minutes: 40).quick?
  end

  test "ingredient_names lists the ingredients" do
    meal = @user.meals.create!(name: "Tuna pasta", meal_type: :lunch)
    meal.meal_ingredients.create!(name: "Tuna", unit: "tin")
    meal.meal_ingredients.create!(name: "Pasta", quantity: 100, unit: "g")
    assert_equal %w[Tuna Pasta], meal.ingredient_names
  end
end
