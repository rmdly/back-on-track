require "test_helper"

module Food
  class MealsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
    end

    test "requires authentication" do
      sign_out
      get food_meals_path
      assert_redirected_to new_session_path
    end

    test "index lists the user's meals" do
      @user.meals.create!(name: "Tuna pasta", meal_type: :lunch)
      get food_meals_path
      assert_response :success
      assert_match "Tuna pasta", response.body
    end

    test "create stores cost in cents" do
      assert_difference -> { @user.meals.count }, 1 do
        post food_meals_path, params: { meal: { name: "Chicken rice", meal_type: "dinner", estimated_cost: "2.50" } }
      end
      meal = @user.meals.order(:created_at).last
      assert_equal 250, meal.estimated_cost_cents
      assert_redirected_to food_meal_path(meal)
    end

    test "create is invalid without a name" do
      assert_no_difference -> { @user.meals.count } do
        post food_meals_path, params: { meal: { name: "", meal_type: "dinner" } }
      end
      assert_response :unprocessable_entity
    end

    test "cannot view another user's meal" do
      others = @other.meals.create!(name: "Theirs", meal_type: :dinner)
      get food_meal_path(others)
      assert_response :not_found
    end
  end
end
