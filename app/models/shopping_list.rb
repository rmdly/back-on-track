class ShoppingList < ApplicationRecord
  belongs_to :user
  belongs_to :store, optional: true
  belongs_to :weekly_plan, optional: true
  has_many :shopping_list_items, -> { ordered }, dependent: :destroy

  enum :status, {
    draft: "draft",
    active: "active",
    completed: "completed",
    archived: "archived"
  }

  # Virtual decimal accessor for form input; persisted as integer cents.
  attr_writer :budget

  def budget
    @budget || (budget_cents && budget_cents / 100.0)
  end

  scope :ordered, -> { order(created_at: :desc) }

  validates :name, presence: true
  validates :budget_cents, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  def estimated_total_cents
    shopping_list_items.sum(&:estimated_total_cents)
  end

  def bought_total_cents
    shopping_list_items.select(&:bought?).sum(&:estimated_total_cents)
  end

  def remaining_total_cents
    estimated_total_cents - bought_total_cents
  end

  def progress_percentage
    items = shopping_list_items.to_a
    return 0 if items.empty?

    (items.count(&:bought?).to_f / items.size * 100).round
  end

  def remaining_items_count
    shopping_list_items.reject(&:bought?).size
  end

  def over_budget?
    budget_cents.present? && estimated_total_cents > budget_cents
  end
end
