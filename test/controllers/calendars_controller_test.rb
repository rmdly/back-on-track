require "test_helper"

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "requires authentication" do
    get calendar_path
    assert_redirected_to new_session_path
  end

  test "shows the current month by default" do
    sign_in_as(@user)
    get calendar_path
    assert_response :success
    assert_select "h1", Date.current.strftime("%B %Y")
  end

  test "shows a specified month" do
    sign_in_as(@user)
    get calendar_path(month: "2026-03")
    assert_response :success
    assert_select "h1", "March 2026"
  end
end

class DayViewTest < ActionDispatch::IntegrationTest
  setup { @user = users(:one) }

  test "root shows today" do
    sign_in_as(@user)
    get root_path
    assert_response :success
    assert_select "h1", "Today"
  end

  test "a dated day view renders that day and creates its plan" do
    sign_in_as(@user)
    date = Date.current + 3
    assert_difference -> { @user.daily_plans.where(date: date).count }, 1 do
      get day_path(date.iso8601)
    end
    assert_response :success
    assert_select "h1", date.strftime("%A")
  end

  test "adding a task on a specific day attaches it to that day's plan" do
    sign_in_as(@user)
    date = Date.current + 2
    post routine_daily_tasks_path, params: { date: date.iso8601, daily_task: { title: "Pack bag" } }
    plan = @user.daily_plans.find_by(date: date)
    assert plan.present?
    assert_equal [ "Pack bag" ], plan.daily_tasks.pluck(:title)
  end
end
