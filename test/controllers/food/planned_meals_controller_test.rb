require "test_helper"

module Food
  class PlannedMealsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
      @plan = WeeklyPlan.current_for(@user, Date.current)
    end

    test "create from a meal snapshots its name" do
      meal = @user.meals.create!(name: "Tuna pasta", meal_type: :lunch)
      assert_difference -> { @plan.planned_meals.count }, 1 do
        post food_planned_meals_path, params: {
          planned_meal: { weekly_plan_id: @plan.id, meal_id: meal.id, planned_on: @plan.starts_on.iso8601, meal_type: "lunch" }
        }
      end
      assert_equal "Tuna pasta", @plan.planned_meals.order(:created_at).last.name
    end

    test "create supports an ad-hoc meal name" do
      post food_planned_meals_path, params: {
        planned_meal: { weekly_plan_id: @plan.id, planned_on: @plan.starts_on.iso8601, meal_type: "dinner", name: "Leftovers" }
      }
      assert_equal "Leftovers", @plan.planned_meals.order(:created_at).last.name
    end

    test "cannot add to another user's weekly plan" do
      others_plan = WeeklyPlan.current_for(@other, Date.current)
      post food_planned_meals_path, params: {
        planned_meal: { weekly_plan_id: others_plan.id, planned_on: others_plan.starts_on.iso8601, meal_type: "dinner", name: "Sneaky" }
      }
      assert_response :not_found
      assert_equal 0, others_plan.planned_meals.count
    end
  end
end
