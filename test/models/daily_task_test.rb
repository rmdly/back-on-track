require "test_helper"

class DailyTaskTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @plan = DailyPlan.find_or_create_for(@user, Date.current)
    @task = @plan.daily_tasks.create!(user: @user, title: "Walk", source: :manual)
  end

  test "new task is open" do
    assert @task.open?
    assert_not @task.completed?
    assert_not @task.skipped?
  end

  test "complete! marks it completed" do
    @task.complete!
    assert @task.completed?
    assert_not @task.open?
    assert @task.completed_at.present?
  end

  test "reopen! clears completion and skip state" do
    @task.complete!
    @task.reopen!
    assert @task.open?
    assert_nil @task.completed_at
    assert_nil @task.skipped_at
  end

  test "skip! records reason and clears completion" do
    @task.complete!
    @task.skip!("Too tired")
    assert @task.skipped?
    assert_not @task.completed?
    assert_equal "Too tired", @task.skip_reason
  end

  test "requires a title" do
    task = @plan.daily_tasks.new(user: @user, title: nil)
    assert_not task.valid?
  end
end
