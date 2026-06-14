class TaskTemplate < ApplicationRecord
  belongs_to :user
  has_many :daily_tasks, dependent: :nullify

  CATEGORIES = %w[health fitness food money home work personal].freeze

  # Bit positions for weekdays_mask. Monday = 0 ... Sunday = 6.
  WEEKDAY_BITS = {
    monday: 0, tuesday: 1, wednesday: 2, thursday: 3,
    friday: 4, saturday: 5, sunday: 6
  }.freeze

  enum :frequency, {
    daily: "daily",
    weekdays: "weekdays",
    weekends: "weekends",
    custom: "custom"
  }

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:position, :created_at) }

  validates :title, presence: true
  validates :frequency, presence: true
  validates :category, inclusion: { in: CATEGORIES }, allow_blank: true

  # Does this template generate a task on the given date?
  def due_on?(date)
    case frequency
    when "daily"    then true
    when "weekdays" then !weekend?(date)
    when "weekends" then weekend?(date)
    when "custom"   then weekday_selected?(date)
    else false
    end
  end

  # Is the date's weekday flagged in weekdays_mask?
  def weekday_selected?(date)
    weekday_enabled?(weekday_key(date))
  end

  # Is a given weekday key (e.g. :monday) flagged in weekdays_mask?
  def weekday_enabled?(key)
    bit = WEEKDAY_BITS.fetch(key.to_sym)
    weekdays_mask.to_i.anybits?(1 << bit)
  end

  # Build (but do not save) a DailyTask for this template on the given plan.
  def build_daily_task_for(daily_plan)
    daily_plan.daily_tasks.build(
      user: user,
      task_template: self,
      title: title,
      category: category,
      important: important,
      position: position,
      source: :template
    )
  end

  private
    def weekday_key(date)
      WEEKDAY_BITS.keys[date.wday.zero? ? 6 : date.wday - 1]
    end

    def weekend?(date)
      date.saturday? || date.sunday?
    end
end
