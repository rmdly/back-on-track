class PlannedMeal < ApplicationRecord
  belongs_to :user
  belongs_to :weekly_plan
  belongs_to :meal, optional: true

  enum :meal_type, breakfast: "breakfast", lunch: "lunch", dinner: "dinner", snack: "snack"

  scope :ordered, -> { order(:planned_on) }

  validates :planned_on, presence: true
  validates :meal_type, presence: true
  validates :name, presence: true
end
