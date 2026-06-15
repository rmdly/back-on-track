module Food
  class PlansController < ApplicationController
    def show
      @date = parse_date(params[:date])
      @weekly_plan = WeeklyPlan.current_for(Current.user, @date)
      @new_planned_meal = PlannedMeal.new
    end

    def generate_shopping_list
      @weekly_plan = Current.user.weekly_plans.find(params[:weekly_plan_id])
      list = Food::ShoppingListBuilder.new(@weekly_plan).build!
      redirect_to shopping_shopping_list_path(list),
                  notice: "Shopping list generated from this week's meals."
    end

    private
      def parse_date(value)
        return Date.current if value.blank?

        Date.iso8601(value.to_s)
      rescue ArgumentError, Date::Error
        Date.current
      end
  end
end
