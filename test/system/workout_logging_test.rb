require "application_system_test_case"

class WorkoutLoggingTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    bench = @user.exercises.create!(name: "Bench Press", exercise_type: :strength)
    @template = @user.workout_templates.create!(name: "Push Day")
    @template.workout_template_exercises.create!(exercise: bench, target_sets: 1, target_reps: 8)
  end

  test "user can start a workout from a template and log a set" do
    sign_in_as @user
    visit training_workout_template_path(@template)

    click_on "Start this workout"
    assert_selector "h1", text: "Push Day"
    assert_text "Bench Press"

    within "##{ActionView::RecordIdentifier.dom_id(@user.workout_sessions.last.workout_exercises.first)}" do
      fill_in "workout_set[weight]", with: "60"
      fill_in "workout_set[reps]", with: "8"
      click_on "Save"
    end

    # 60kg × 8 reps = 480 total volume, shown in the summary
    assert_text "480", wait: 5
  end

  test "user can finish a workout" do
    session = @user.workout_sessions.create!(performed_on: Date.current, started_at: Time.current, name: "Push Day")
    sign_in_as @user
    visit training_workout_session_path(session)

    click_on "Finish workout"
    assert_text "Workout finished"
    assert_text "Done"
  end
end
