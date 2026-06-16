require "test_helper"

module Training
  class WorkoutSetsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
      @session = @user.workout_sessions.create!(performed_on: Date.current)
      bench = @user.exercises.create!(name: "Bench Press", exercise_type: :strength)
      @workout_exercise = @session.workout_exercises.create!(exercise: bench)
    end

    test "create adds a set to the exercise" do
      assert_difference -> { @workout_exercise.workout_sets.count }, 1 do
        post training_workout_exercise_workout_sets_path(@workout_exercise),
          params: { workout_set: { weight: "60", reps: "10" } }
      end
      set = @workout_exercise.workout_sets.order(:created_at).last
      assert_equal 60, set.weight
      assert_equal 10, set.reps
    end

    test "complete toggles the set" do
      set = @workout_exercise.workout_sets.create!(weight: 60, reps: 10)
      patch complete_training_workout_set_path(set)
      assert set.reload.completed?
    end

    test "duplicate copies weight and reps into a new set" do
      set = @workout_exercise.workout_sets.create!(weight: 60, reps: 10)
      assert_difference -> { @workout_exercise.workout_sets.count }, 1 do
        post duplicate_training_workout_set_path(set)
      end
      copy = @workout_exercise.workout_sets.order(:created_at).last
      assert_equal 60, copy.weight
      assert_equal 10, copy.reps
    end

    test "cannot add a set to another user's exercise" do
      others_session = @other.workout_sessions.create!(performed_on: Date.current)
      others_exercise = others_session.workout_exercises.create!(
        exercise: @other.exercises.create!(name: "Squat", exercise_type: :strength)
      )
      post training_workout_exercise_workout_sets_path(others_exercise),
        params: { workout_set: { weight: "60", reps: "10" } }
      assert_response :not_found
    end
  end
end
