class WorkoutExercise < ApplicationRecord
  belongs_to :workout_session
  belongs_to :exercise
  has_many :workout_sets, -> { ordered }, dependent: :destroy

  scope :ordered, -> { order(:position, :created_at) }

  delegate :user_id, to: :workout_session

  def total_volume
    workout_sets.sum(&:volume)
  end

  # The same exercise as logged in the most recent earlier session — used to
  # show "last time" while logging. One of the most useful gym-tracking cues.
  def previous_performance
    WorkoutExercise
      .joins(:workout_session)
      .where(exercise_id: exercise_id, workout_sessions: { user_id: workout_session.user_id })
      .where.not(id: id)
      .where("workout_sessions.performed_on < :date OR " \
             "(workout_sessions.performed_on = :date AND workout_exercises.created_at < :created)",
             date: workout_session.performed_on, created: created_at)
      .order("workout_sessions.performed_on DESC, workout_exercises.created_at DESC")
      .first
  end
end
