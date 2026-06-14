class DailyPlan < ApplicationRecord
  belongs_to :user
  has_many :daily_tasks, -> { ordered }, dependent: :destroy

  validates :date, presence: true, uniqueness: { scope: :user_id }

  def self.find_or_create_for(user, date)
    user.daily_plans.find_or_create_by!(date: date)
  end

  # Idempotently create DailyTasks for every active template due on this date.
  # Refreshing must not duplicate template-generated tasks, which the unique
  # index on (daily_plan_id, task_template_id) also enforces at the DB level.
  def populate_from_templates!
    due_templates = user.task_templates.active.ordered.select { |template| template.due_on?(date) }

    due_templates.each do |template|
      daily_tasks.find_or_create_by!(task_template: template) do |task|
        task.user = user
        task.title = template.title
        task.category = template.category
        task.important = template.important
        task.position = template.position
        task.source = :template
      end
    end
  end

  def completion_percentage
    counted = daily_tasks.reject(&:skipped?)
    return 0 if counted.empty?

    (counted.count(&:completed?).to_f / counted.size * 100).round
  end

  def completed_tasks_count
    daily_tasks.count(&:completed?)
  end

  def open_tasks_count
    daily_tasks.count(&:open?)
  end

  def skipped_tasks_count
    daily_tasks.count(&:skipped?)
  end
end
