require "application_system_test_case"

class MealPlanningTest < ApplicationSystemTestCase
  setup { @user = users(:one) }

  test "user can create a meal with an ingredient" do
    sign_in_as @user

    click_on "Food"
    click_on "Meals"
    click_on "New meal"
    assert_selector "h1", text: "New meal"
    fill_in "Name", with: "Chicken rice bowl"
    click_on "Create meal"

    assert_selector "h1", text: "Chicken rice bowl"
    fill_in "Ingredient", with: "Rice"
    fill_in "Qty", with: "100"
    fill_in "Unit", with: "g"
    click_on "Add"

    assert_text "Rice"
    assert_text "100 g"
  end

  test "user can plan a meal and generate a shopping list" do
    meal = @user.meals.create!(name: "Tuna pasta", meal_type: :lunch)
    meal.meal_ingredients.create!(name: "Pasta", quantity: 100, unit: "g")
    meal.meal_ingredients.create!(name: "Tuna", quantity: 1, unit: "tin")

    sign_in_as @user
    visit food_plan_path

    select "Tuna pasta", from: "planned_meal[meal_id]"
    click_on "Add"
    assert_text "Tuna pasta"

    click_on "Generate shopping list"
    assert_text "Shopping list generated"
    assert_text "Pasta"
    assert_text "Tuna"
  end
end
