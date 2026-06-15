require "test_helper"

class WeeklyPlanTest < ActiveSupport::TestCase
  setup { @user = users(:one) }

  test "start_date_for returns the Monday of the week" do
    wednesday = Date.new(2026, 6, 17)
    assert_equal Date.new(2026, 6, 15), WeeklyPlan.start_date_for(wednesday, week_starts_on: :monday)
  end

  test "current_for creates one plan per week and is idempotent" do
    plan = WeeklyPlan.current_for(@user, Date.new(2026, 6, 17))
    again = WeeklyPlan.current_for(@user, Date.new(2026, 6, 19)) # same week
    assert_equal plan.id, again.id
    assert_equal 1, @user.weekly_plans.count
  end

  test "sets ends_on to six days after starts_on" do
    plan = WeeklyPlan.current_for(@user, Date.new(2026, 6, 17))
    assert_equal plan.starts_on + 6, plan.ends_on
  end

  test "days returns the seven dates of the week" do
    plan = WeeklyPlan.current_for(@user, Date.new(2026, 6, 17))
    assert_equal 7, plan.days.size
    assert_equal plan.starts_on, plan.days.first
    assert_equal plan.ends_on, plan.days.last
  end

  test "planned_meals_for returns meals on that date" do
    plan = WeeklyPlan.current_for(@user, Date.new(2026, 6, 17))
    day = plan.starts_on
    on_day = plan.planned_meals.create!(user: @user, planned_on: day, meal_type: :dinner, name: "Tuna pasta")
    plan.planned_meals.create!(user: @user, planned_on: day + 1, meal_type: :dinner, name: "Mince and rice")

    assert_equal [on_day], plan.planned_meals_for(day)
  end
end
