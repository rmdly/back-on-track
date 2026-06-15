class ShoppingListItem < ApplicationRecord
  belongs_to :user
  belongs_to :shopping_list
  belongs_to :shopping_item, optional: true
  belongs_to :store, optional: true

  # Virtual decimal accessor for form input; persisted as integer cents.
  attr_writer :estimated_unit_price

  def estimated_unit_price
    @estimated_unit_price || (estimated_unit_price_cents && estimated_unit_price_cents / 100.0)
  end

  scope :ordered, -> { order(:position, :created_at) }
  scope :bought, -> { where.not(bought_at: nil) }
  scope :unbought, -> { where(bought_at: nil) }

  validates :name, presence: true
  validates :quantity, numericality: { greater_than: 0 }, allow_nil: true
  validates :estimated_unit_price_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def bought?
    bought_at.present?
  end

  def mark_bought!
    update!(bought_at: Time.current)
  end

  def mark_unbought!
    update!(bought_at: nil)
  end

  # Snapshot price * quantity. Quantity defaults to 1 when not specified.
  def estimated_total_cents
    return 0 if estimated_unit_price_cents.blank?

    (estimated_unit_price_cents * (quantity || 1)).round
  end
end
