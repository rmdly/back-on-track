class Store < ApplicationRecord
  belongs_to :user
  has_many :shopping_items, dependent: :nullify
  has_many :shopping_lists, dependent: :nullify
  has_many :shopping_list_items, dependent: :nullify

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :name) }

  validates :name, presence: true, uniqueness: { scope: :user_id, case_sensitive: false }
end
