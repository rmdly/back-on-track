require "test_helper"

class DashboardsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "redirects unauthenticated users to sign in" do
    get root_path
    assert_redirected_to new_session_path
  end

  test "shows today for authenticated users and populates routine tasks" do
    @user.task_templates.create!(title: "Drink water", frequency: :daily)
    sign_in_as(@user)

    get root_path
    assert_response :success
    assert_select "h1", "Today"
    assert_match "Drink water", response.body
  end

  test "refreshing today does not duplicate template tasks" do
    @user.task_templates.create!(title: "Drink water", frequency: :daily)
    sign_in_as(@user)

    get root_path
    get root_path

    plan = @user.daily_plans.find_by(date: Date.current)
    assert_equal 1, plan.daily_tasks.where(title: "Drink water").count
  end
end
