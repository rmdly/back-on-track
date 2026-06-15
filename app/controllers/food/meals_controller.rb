module Food
  class MealsController < ApplicationController
    before_action :set_meal, only: %i[show edit update destroy]

    def index
      @meals = Current.user.meals.ordered
    end

    def show
      @meal_ingredient = MealIngredient.new
    end

    def new
      @meal = Current.user.meals.new(active: true)
    end

    def create
      @meal = Current.user.meals.new(meal_params)

      if @meal.save
        redirect_to food_meal_path(@meal), notice: "Meal created. Add its ingredients below."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @meal.update(meal_params)
        redirect_to food_meal_path(@meal), notice: "Meal updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @meal.destroy!
      redirect_to food_meals_path, notice: "Meal removed.", status: :see_other
    end

    private
      def set_meal
        @meal = Current.user.meals.find(params[:id])
      end

      def meal_params
        permitted = params.require(:meal).permit(
          :name, :meal_type, :description, :instructions, :prep_time_minutes,
          :protein_level, :effort_level, :active, :estimated_cost
        )
        if permitted.key?(:estimated_cost)
          cost = permitted.delete(:estimated_cost)
          permitted[:estimated_cost_cents] = cost.present? ? (cost.to_d * 100).round : nil
        end
        permitted
      end
  end
end
