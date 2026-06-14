require "test_helper"

class DailyPlanTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @date = Date.current
  end

  test "find_or_create_for creates one plan per user and date" do
    plan = DailyPlan.find_or_create_for(@user, @date)
    assert plan.persisted?

    same = DailyPlan.find_or_create_for(@user, @date)
    assert_equal plan.id, same.id
    assert_equal 1, @user.daily_plans.where(date: @date).count
  end

  test "populate_from_templates! creates tasks for due active templates" do
    @user.task_templates.create!(title: "Water", frequency: :daily)
    @user.task_templates.create!(title: "Inactive habit", frequency: :daily, active: false)

    plan = DailyPlan.find_or_create_for(@user, @date)
    plan.populate_from_templates!

    titles = plan.daily_tasks.map(&:title)
    assert_includes titles, "Water"
    assert_not_includes titles, "Inactive habit"
    assert plan.daily_tasks.all?(&:template?)
  end

  test "populate_from_templates! is idempotent and does not duplicate" do
    @user.task_templates.create!(title: "Water", frequency: :daily)
    plan = DailyPlan.find_or_create_for(@user, @date)

    plan.populate_from_templates!
    plan.populate_from_templates!

    assert_equal 1, plan.daily_tasks.where(title: "Water").count
  end

  test "completion_percentage ignores skipped tasks" do
    plan = DailyPlan.find_or_create_for(@user, @date)
    done = plan.daily_tasks.create!(user: @user, title: "A", source: :manual)
    plan.daily_tasks.create!(user: @user, title: "B", source: :manual)
    skipped = plan.daily_tasks.create!(user: @user, title: "C", source: :manual)

    done.complete!
    skipped.skip!

    # 1 completed out of 2 counted (B open, C skipped is excluded) => 50%
    assert_equal 50, plan.reload.completion_percentage
    assert_equal 1, plan.completed_tasks_count
    assert_equal 1, plan.open_tasks_count
    assert_equal 1, plan.skipped_tasks_count
  end

  test "completion_percentage is zero when there are no countable tasks" do
    plan = DailyPlan.find_or_create_for(@user, @date)
    assert_equal 0, plan.completion_percentage
  end
end
