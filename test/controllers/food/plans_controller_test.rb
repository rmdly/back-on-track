require "test_helper"

module Food
  class PlansControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      sign_in_as(@user)
    end

    test "requires authentication" do
      sign_out
      get food_plan_path
      assert_redirected_to new_session_path
    end

    test "show renders the current week" do
      get food_plan_path
      assert_response :success
      assert_select "h1", "This week’s meals"
    end

    test "generate_shopping_list builds a list from planned meals and redirects to it" do
      plan = WeeklyPlan.current_for(@user, Date.current)
      meal = @user.meals.create!(name: "Chicken rice", meal_type: :dinner)
      meal.meal_ingredients.create!(name: "Rice", quantity: 100, unit: "g")
      plan.planned_meals.create!(user: @user, meal: meal, planned_on: plan.starts_on, meal_type: :dinner, name: meal.name)

      assert_difference -> { @user.shopping_lists.count }, 1 do
        post food_plan_generate_shopping_list_path(weekly_plan_id: plan.id)
      end
      list = @user.shopping_lists.order(:created_at).last
      assert_redirected_to shopping_shopping_list_path(list)
      assert_equal [ "Rice" ], list.shopping_list_items.pluck(:name)
    end
  end
end
