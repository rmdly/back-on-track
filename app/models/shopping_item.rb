class ShoppingItem < ApplicationRecord
  belongs_to :user
  belongs_to :store, optional: true
  has_many :shopping_list_items, dependent: :nullify

  CATEGORIES = %w[protein carbs fruit_veg dairy snacks drinks household toiletries other].freeze

  # Virtual decimal accessor for form input; persisted as integer cents.
  attr_writer :estimated_unit_price

  def estimated_unit_price
    @estimated_unit_price || display_price
  end

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  validates :name, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true
  validates :default_quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :estimated_unit_price_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def estimated_total_for(quantity)
    return nil if estimated_unit_price_cents.blank?

    (estimated_unit_price_cents * (quantity || 1)).round
  end

  def display_price
    return nil if estimated_unit_price_cents.blank?

    estimated_unit_price_cents / 100.0
  end
end
