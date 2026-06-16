class WorkoutSession < ApplicationRecord
  belongs_to :user
  belongs_to :workout_template, optional: true
  belongs_to :planned_workout, optional: true
  has_many :workout_exercises, -> { ordered }, dependent: :destroy
  has_many :workout_sets, through: :workout_exercises

  scope :recent, -> { order(performed_on: :desc, created_at: :desc) }

  validates :performed_on, presence: true

  def completed?
    completed_at.present?
  end

  def total_sets
    workout_sets.size
  end

  def total_volume
    workout_sets.sum(&:volume)
  end

  def duration_minutes
    return nil if started_at.blank?

    finish = completed_at || Time.current
    ((finish - started_at) / 60).round
  end

  # Build a session from a template: copy its exercises (and blank target sets).
  def populate_from_template!
    return unless workout_template

    workout_template.workout_template_exercises.ordered.each do |template_exercise|
      workout_exercise = workout_exercises.create!(
        exercise: template_exercise.exercise,
        position: template_exercise.position
      )
      (template_exercise.target_sets || 0).times do |index|
        workout_exercise.workout_sets.create!(
          position: index,
          reps: template_exercise.target_reps,
          weight: template_exercise.target_weight
        )
      end
    end
  end
end
