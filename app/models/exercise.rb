class Exercise < ApplicationRecord
  belongs_to :user
  has_many :workout_template_exercises, dependent: :destroy
  has_many :workout_exercises, dependent: :destroy

  EXERCISE_TYPES = %w[strength cardio bodyweight mobility].freeze
  MUSCLE_GROUPS = %w[chest back shoulders legs arms core full_body cardio other].freeze

  enum :exercise_type, { strength: "strength", cardio: "cardio", bodyweight: "bodyweight", mobility: "mobility" }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
  validates :exercise_type, presence: true
  validates :muscle_group, inclusion: { in: MUSCLE_GROUPS }, allow_blank: true

  # Heaviest single set the user has ever logged for this exercise.
  def best_set
    WorkoutSet.joins(workout_exercise: :workout_session)
              .where(workout_exercises: { exercise_id: id })
              .where(workout_sessions: { user_id: user_id })
              .where.not(weight: nil)
              .order(weight: :desc)
              .first
  end
end
