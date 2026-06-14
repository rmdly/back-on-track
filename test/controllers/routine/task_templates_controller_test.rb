require "test_helper"

module Routine
  class TaskTemplatesControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
    end

    test "requires authentication" do
      sign_out
      get routine_task_templates_path
      assert_redirected_to new_session_path
    end

    test "index lists the user's templates" do
      @user.task_templates.create!(title: "Water", frequency: :daily)
      get routine_task_templates_path
      assert_response :success
      assert_match "Water", response.body
    end

    test "create with custom weekdays builds the mask" do
      assert_difference -> { @user.task_templates.count }, 1 do
        post routine_task_templates_path, params: {
          task_template: { title: "Gym", frequency: "custom", weekdays: %w[monday wednesday] }
        }
      end
      template = @user.task_templates.order(:created_at).last
      assert template.weekday_enabled?(:monday)
      assert template.weekday_enabled?(:wednesday)
      assert_not template.weekday_enabled?(:tuesday)
    end

    test "create is invalid without a title" do
      assert_no_difference -> { @user.task_templates.count } do
        post routine_task_templates_path, params: { task_template: { title: "", frequency: "daily" } }
      end
      assert_response :unprocessable_entity
    end

    test "cannot edit another user's template" do
      others = @other.task_templates.create!(title: "Theirs", frequency: :daily)
      get edit_routine_task_template_path(others)
      assert_response :not_found
    end
  end
end
