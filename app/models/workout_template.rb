class WorkoutTemplate < ApplicationRecord
  belongs_to :user
  has_many :workout_template_exercises, -> { ordered }, dependent: :destroy
  has_many :exercises, through: :workout_template_exercises
  has_many :workout_sessions, dependent: :nullify

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  validates :name, presence: true
end
