require "application_system_test_case"

class RoutineTest < ApplicationSystemTestCase
  setup { @user = users(:one) }

  test "user can add a one-off task on Today" do
    sign_in_as @user

    fill_in "Add a task for today…", with: "Call the dentist"
    click_on "Add"
    assert_text "Call the dentist"
    assert_text "0 of 1 done"
  end

  test "user can complete a task on Today" do
    plan = DailyPlan.find_or_create_for(@user, Date.current)
    plan.daily_tasks.create!(user: @user, title: "Call the dentist", source: :manual)
    sign_in_as @user

    assert_text "Call the dentist"
    click_button "Complete Call the dentist"
    assert_text "100%"
  end

  test "user can create a recurring routine item and see it on Today" do
    sign_in_as @user

    click_on "Routine"
    click_on "New"
    assert_selector "h1", text: "New routine item"
    fill_in "Title", with: "Go for a walk"
    click_on "Add routine item"
    assert_text "Recurring habits"
    assert_text "Go for a walk"

    visit root_path
    assert_text "Go for a walk"
  end

  test "a due recurring routine item is generated on Today" do
    @user.task_templates.create!(title: "Drink 2L water", frequency: :daily)
    sign_in_as @user
    assert_text "Drink 2L water"
  end
end
