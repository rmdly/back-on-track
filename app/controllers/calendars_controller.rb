class CalendarsController < ApplicationController
  def show
    @today = Date.current
    @month = parse_month(params[:month])
    week_start = Current.user.week_start_symbol

    @grid_start = @month.beginning_of_month.beginning_of_week(week_start)
    @grid_end = @month.end_of_month.end_of_week(week_start)
    @weeks = (@grid_start..@grid_end).to_a.each_slice(7).to_a
    @plans_by_date = Current.user.daily_plans
                                 .where(date: @grid_start..@grid_end)
                                 .includes(:daily_tasks)
                                 .index_by(&:date)
  end

  private
    def parse_month(value)
      return Date.current.beginning_of_month if value.blank?

      Date.strptime(value.to_s, "%Y-%m").beginning_of_month
    rescue ArgumentError, Date::Error
      Date.current.beginning_of_month
    end
end
