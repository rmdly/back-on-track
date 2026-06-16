class WeeklyPlan < ApplicationRecord
  belongs_to :user
  has_many :planned_meals, dependent: :destroy
  has_many :planned_workouts, dependent: :destroy
  has_many :shopping_lists, dependent: :nullify

  before_validation :set_ends_on

  validates :starts_on, presence: true, uniqueness: { scope: :user_id }

  # Virtual decimal accessor for form input; persisted as integer cents.
  attr_writer :food_budget

  def food_budget
    @food_budget || (food_budget_cents && food_budget_cents / 100.0)
  end

  # Monday-based (or user-preferred) start of the week containing +date+.
  def self.start_date_for(date, week_starts_on: :monday)
    date.beginning_of_week(week_starts_on)
  end

  def self.current_for(user, date = Date.current)
    start = start_date_for(date, week_starts_on: user.week_start_symbol)
    user.weekly_plans.find_or_create_by!(starts_on: start)
  end

  def days
    (starts_on..ends_on).to_a
  end

  def planned_meals_for(date)
    planned_meals.select { |meal| meal.planned_on == date }
  end

  def planned_workouts_for(date)
    planned_workouts.select { |workout| workout.planned_on == date }
  end

  def shopping_total_cents
    shopping_lists.sum(&:estimated_total_cents)
  end

  def over_food_budget?
    food_budget_cents.present? && shopping_total_cents > food_budget_cents
  end

  private
    def set_ends_on
      self.ends_on = starts_on + 6 if starts_on.present?
    end
end
