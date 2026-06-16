class PlannedWorkout < ApplicationRecord
  belongs_to :user
  belongs_to :weekly_plan, optional: true
  belongs_to :workout_template, optional: true
  belongs_to :workout_session, optional: true

  enum :status, { planned: "planned", completed: "completed", skipped: "skipped" }

  scope :ordered, -> { order(:planned_on) }

  validates :planned_on, presence: true
  validates :name, presence: true
end
