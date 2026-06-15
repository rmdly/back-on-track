class Meal < ApplicationRecord
  belongs_to :user
  has_many :meal_ingredients, -> { ordered }, dependent: :destroy
  has_many :planned_meals, dependent: :nullify

  MEAL_TYPES = %w[breakfast lunch dinner snack].freeze
  CHEAP_THRESHOLD_CENTS = 300
  QUICK_THRESHOLD_MINUTES = 15

  enum :meal_type, { breakfast: "breakfast", lunch: "lunch", dinner: "dinner", snack: "snack" }
  enum :protein_level, { low: "low", medium: "medium", high: "high" }, prefix: :protein
  enum :effort_level, { easy: "easy", medium: "medium", high: "high" }, prefix: :effort

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  validates :name, presence: true
  validates :meal_type, presence: true
  validates :estimated_cost_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :prep_time_minutes, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Virtual decimal accessor for form input; persisted as integer cents.
  attr_writer :estimated_cost

  def estimated_cost
    @estimated_cost || (estimated_cost_cents && estimated_cost_cents / 100.0)
  end

  def cheap?
    estimated_cost_cents.present? && estimated_cost_cents <= CHEAP_THRESHOLD_CENTS
  end

  def high_protein?
    protein_level == "high"
  end

  def quick?
    prep_time_minutes.present? && prep_time_minutes <= QUICK_THRESHOLD_MINUTES
  end

  def ingredient_names
    meal_ingredients.map(&:name)
  end
end
