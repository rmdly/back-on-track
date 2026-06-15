class MealIngredient < ApplicationRecord
  belongs_to :meal
  belongs_to :shopping_item, optional: true

  scope :ordered, -> { order(:position, :created_at) }

  validates :name, presence: true
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
end
