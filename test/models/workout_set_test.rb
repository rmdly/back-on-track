require "test_helper"

class WorkoutSetTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    session = @user.workout_sessions.create!(performed_on: Date.current)
    exercise = @user.exercises.create!(name: "Bench Press", exercise_type: :strength)
    @workout_exercise = session.workout_exercises.create!(exercise: exercise)
  end

  test "volume is weight times reps" do
    set = @workout_exercise.workout_sets.create!(weight: 60, reps: 10)
    assert_equal 600, set.volume
  end

  test "volume is zero when weight or reps missing" do
    assert_equal 0, @workout_exercise.workout_sets.create!(reps: 10).volume
    assert_equal 0, @workout_exercise.workout_sets.create!(weight: 60).volume
  end

  test "complete! marks the set completed" do
    set = @workout_exercise.workout_sets.create!(weight: 60, reps: 10)
    assert_not set.completed?
    set.complete!
    assert set.completed?
  end
end
