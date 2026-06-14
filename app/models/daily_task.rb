class DailyTask < ApplicationRecord
  belongs_to :user
  belongs_to :daily_plan
  belongs_to :task_template, optional: true

  CATEGORIES = TaskTemplate::CATEGORIES

  enum :source, {
    template: "template",
    manual: "manual"
  }

  scope :ordered, -> { order(:position, :created_at) }
  scope :open, -> { where(completed_at: nil, skipped_at: nil) }

  validates :title, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  def completed?
    completed_at.present?
  end

  def skipped?
    skipped_at.present?
  end

  def open?
    !completed? && !skipped?
  end

  def complete!
    update!(completed_at: Time.current, skipped_at: nil, skip_reason: nil)
  end

  def reopen!
    update!(completed_at: nil, skipped_at: nil, skip_reason: nil)
  end

  def skip!(reason = nil)
    update!(skipped_at: Time.current, skip_reason: reason, completed_at: nil)
  end
end
