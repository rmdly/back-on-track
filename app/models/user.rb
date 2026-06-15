class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  # Routine domain (Phase 1)
  has_many :task_templates, dependent: :destroy
  has_many :daily_plans, dependent: :destroy
  has_many :daily_tasks, dependent: :destroy

  # Shopping domain (Phase 2)
  has_many :stores, dependent: :destroy
  has_many :shopping_items, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :shopping_list_items, dependent: :destroy

  WEEK_START_DAYS = %w[monday sunday].freeze

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :email_address, presence: true, uniqueness: true
  validates :time_zone, presence: true
  validates :week_starts_on, presence: true, inclusion: { in: WEEK_START_DAYS }

  # Symbol form used by date math helpers (e.g. Date#beginning_of_week).
  def week_start_symbol
    week_starts_on.to_sym
  end
end
