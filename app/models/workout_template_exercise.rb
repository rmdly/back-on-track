class WorkoutTemplateExercise < ApplicationRecord
  belongs_to :workout_template
  belongs_to :exercise

  scope :ordered, -> { order(:position, :created_at) }

  validates :target_sets, numericality: { greater_than: 0 }, allow_nil: true
  validates :target_reps, numericality: { greater_than: 0 }, allow_nil: true
end
