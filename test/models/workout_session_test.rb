require "test_helper"

class WorkoutSessionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @bench = @user.exercises.create!(name: "Bench Press", exercise_type: :strength)
  end

  def session_with_sets(sets)
    session = @user.workout_sessions.create!(performed_on: Date.current)
    we = session.workout_exercises.create!(exercise: @bench)
    sets.each { |weight, reps| we.workout_sets.create!(weight: weight, reps: reps) }
    session
  end

  test "total_sets and total_volume aggregate across exercises" do
    session = session_with_sets([[60, 10], [60, 8]])
    assert_equal 2, session.total_sets
    assert_equal 60 * 10 + 60 * 8, session.total_volume
  end

  test "completed? reflects completed_at" do
    session = @user.workout_sessions.create!(performed_on: Date.current)
    assert_not session.completed?
    session.update!(completed_at: Time.current)
    assert session.completed?
  end

  test "populate_from_template! copies exercises and blank target sets" do
    template = @user.workout_templates.create!(name: "Push Day")
    template.workout_template_exercises.create!(exercise: @bench, target_sets: 3, target_reps: 8, target_weight: 60)

    session = @user.workout_sessions.create!(performed_on: Date.current, workout_template: template)
    session.populate_from_template!

    assert_equal 1, session.workout_exercises.count
    we = session.workout_exercises.first
    assert_equal @bench, we.exercise
    assert_equal 3, we.workout_sets.count
    assert_equal [8, 8, 8], we.workout_sets.map(&:reps)
  end

  test "previous_performance finds the same exercise in an earlier session" do
    old = @user.workout_sessions.create!(performed_on: Date.current - 7)
    old_we = old.workout_exercises.create!(exercise: @bench)
    old_we.workout_sets.create!(weight: 50, reps: 10)

    today = @user.workout_sessions.create!(performed_on: Date.current)
    today_we = today.workout_exercises.create!(exercise: @bench)

    assert_equal old_we, today_we.previous_performance
  end
end
