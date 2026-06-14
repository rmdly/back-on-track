class DashboardsController < ApplicationController
  def show
    @date = Date.current
    @daily_plan = DailyPlan.find_or_create_for(Current.user, @date)
    @daily_plan.populate_from_templates!
    @new_task = DailyTask.new
  end
end
