require "test_helper"

module Training
  class WorkoutSessionsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
    end

    test "requires authentication" do
      sign_out
      get training_workout_sessions_path
      assert_redirected_to new_session_path
    end

    test "start from a template copies its exercises and sets" do
      bench = @user.exercises.create!(name: "Bench Press", exercise_type: :strength)
      template = @user.workout_templates.create!(name: "Push Day")
      template.workout_template_exercises.create!(exercise: bench, target_sets: 3, target_reps: 8)

      assert_difference -> { @user.workout_sessions.count }, 1 do
        post training_workout_sessions_path, params: { workout_session: { workout_template_id: template.id } }
      end
      session = @user.workout_sessions.order(:created_at).last
      assert_equal "Push Day", session.name
      assert_equal 1, session.workout_exercises.count
      assert_equal 3, session.workout_exercises.first.workout_sets.count
      assert_redirected_to training_workout_session_path(session)
    end

    test "finish marks the session completed" do
      session = @user.workout_sessions.create!(performed_on: Date.current, started_at: Time.current)
      patch finish_training_workout_session_path(session)
      assert session.reload.completed?
    end

    test "cannot view another user's session" do
      others = @other.workout_sessions.create!(performed_on: Date.current)
      get training_workout_session_path(others)
      assert_response :not_found
    end
  end
end
