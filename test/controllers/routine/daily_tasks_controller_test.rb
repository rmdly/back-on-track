require "test_helper"

module Routine
  class DailyTasksControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
    end

    test "create adds a manual task to today" do
      assert_difference -> { @user.daily_tasks.count }, 1 do
        post routine_daily_tasks_path, params: { daily_task: { title: "Call mum" } }
      end
      task = @user.daily_tasks.order(:created_at).last
      assert_equal "Call mum", task.title
      assert task.manual?
      assert_redirected_to root_path
    end

    test "complete marks a task completed" do
      task = create_task
      patch complete_routine_daily_task_path(task)
      assert task.reload.completed?
    end

    test "reopen clears completion" do
      task = create_task
      task.complete!
      patch reopen_routine_daily_task_path(task)
      assert task.reload.open?
    end

    test "skip marks a task skipped with a reason" do
      task = create_task
      patch skip_routine_daily_task_path(task), params: { skip_reason: "Sick" }
      assert task.reload.skipped?
      assert_equal "Sick", task.skip_reason
    end

    test "destroy removes the task" do
      task = create_task
      assert_difference -> { @user.daily_tasks.count }, -1 do
        delete routine_daily_task_path(task)
      end
    end

    test "cannot act on another user's task" do
      others_plan = DailyPlan.find_or_create_for(@other, Date.current)
      others_task = others_plan.daily_tasks.create!(user: @other, title: "Secret", source: :manual)

      patch complete_routine_daily_task_path(others_task)
      assert_response :not_found
      assert_not others_task.reload.completed?
    end

    private
      def create_task
        plan = DailyPlan.find_or_create_for(@user, Date.current)
        plan.daily_tasks.create!(user: @user, title: "Walk", source: :manual)
      end
  end
end
