module Food
  class PlannedMealsController < ApplicationController
    before_action :set_weekly_plan, only: :create
    before_action :set_planned_meal, only: %i[edit update destroy]

    def create
      @planned_meal = @weekly_plan.planned_meals.new(planned_meal_params)
      @planned_meal.user = Current.user
      apply_meal_snapshot

      if @planned_meal.save
        respond_with_plan
      else
        respond_with_plan(status: :unprocessable_entity)
      end
    end

    def edit
    end

    def update
      apply_meal_snapshot
      if @planned_meal.update(planned_meal_params)
        redirect_to food_plan_path(date: @planned_meal.planned_on), notice: "Meal updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @planned_meal.destroy!
      respond_with_plan(notice: "Meal removed.")
    end

    private
      def set_weekly_plan
        @weekly_plan = Current.user.weekly_plans.find(params[:planned_meal][:weekly_plan_id])
      end

      def set_planned_meal
        @planned_meal = Current.user.planned_meals.find(params[:id])
        @weekly_plan = @planned_meal.weekly_plan
      end

      def planned_meal_params
        params.require(:planned_meal).permit(:meal_id, :planned_on, :meal_type, :name, :notes)
      end

      # Snapshot the meal's name so the plan still reads well if the template changes.
      def apply_meal_snapshot
        return if @planned_meal.name.present?

        meal = Current.user.meals.find_by(id: @planned_meal.meal_id)
        @planned_meal.name = meal.name if meal
      end

      def respond_with_plan(notice: nil, status: :ok)
        @weekly_plan.reload
        @new_planned_meal = PlannedMeal.new
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "meal_plan_body",
              partial: "food/plans/plan_body",
              locals: { weekly_plan: @weekly_plan, new_planned_meal: @new_planned_meal }
            ), status: status
          end
          format.html { redirect_to food_plan_path(date: @weekly_plan.starts_on), notice: notice }
        end
      end
  end
end
