class DashboardsController < ApplicationController
  def show
    @today = Date.current
    @date = parse_date(params[:date])
    @daily_plan = DailyPlan.find_or_create_for(Current.user, @date)
    @daily_plan.populate_from_templates!
    @new_task = DailyTask.new
    @active_shopping_lists = Current.user.shopping_lists.active.ordered

    weekly_plan = WeeklyPlan.current_for(Current.user, @date)
    @planned_meals = weekly_plan.planned_meals_for(@date)
                                .sort_by { |meal| PlannedMeal.meal_types.keys.index(meal.meal_type) }
    @planned_workouts = weekly_plan.planned_workouts_for(@date)
  end

  private
    def parse_date(value)
      return Date.current if value.blank?

      Date.iso8601(value.to_s)
    rescue ArgumentError, Date::Error
      Date.current
    end
end
