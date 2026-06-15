class DashboardsController < ApplicationController
  def show
    @today = Date.current
    @date = parse_date(params[:date])
    @daily_plan = DailyPlan.find_or_create_for(Current.user, @date)
    @daily_plan.populate_from_templates!
    @new_task = DailyTask.new
    @active_shopping_lists = Current.user.shopping_lists.active.ordered
  end

  private
    def parse_date(value)
      return Date.current if value.blank?

      Date.iso8601(value.to_s)
    rescue ArgumentError, Date::Error
      Date.current
    end
end
