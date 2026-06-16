class WorkoutSet < ApplicationRecord
  belongs_to :workout_exercise

  scope :ordered, -> { order(:position, :created_at) }

  validates :reps, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def volume
    (weight || 0) * (reps || 0)
  end

  def completed?
    completed_at.present?
  end

  def complete!
    update!(completed_at: Time.current)
  end
end
