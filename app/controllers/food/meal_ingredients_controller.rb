module Food
  class MealIngredientsController < ApplicationController
    before_action :set_meal, only: :create
    before_action :set_meal_ingredient, only: %i[edit update destroy]

    def create
      @meal_ingredient = @meal.meal_ingredients.new(meal_ingredient_params)
      apply_library_snapshot

      if @meal_ingredient.save
        respond_with_ingredients
      else
        respond_with_ingredients(status: :unprocessable_entity)
      end
    end

    def edit
    end

    def update
      if @meal_ingredient.update(meal_ingredient_params)
        redirect_to food_meal_path(@meal), notice: "Ingredient updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @meal_ingredient.destroy!
      respond_with_ingredients(notice: "Ingredient removed.")
    end

    private
      def set_meal
        @meal = Current.user.meals.find(params[:meal_id])
      end

      def set_meal_ingredient
        @meal_ingredient = MealIngredient.joins(:meal)
                                         .where(meals: { user_id: Current.user.id })
                                         .find(params[:id])
        @meal = @meal_ingredient.meal
      end

      def meal_ingredient_params
        params.require(:meal_ingredient).permit(:name, :shopping_item_id, :quantity, :unit)
      end

      def apply_library_snapshot
        library_item = Current.user.shopping_items.find_by(id: @meal_ingredient.shopping_item_id)
        return unless library_item

        @meal_ingredient.name = library_item.name if @meal_ingredient.name.blank?
        @meal_ingredient.unit ||= library_item.default_unit
        @meal_ingredient.quantity ||= library_item.default_quantity
      end

      def respond_with_ingredients(notice: nil, status: :ok)
        @meal.reload
        @new_ingredient = MealIngredient.new
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "meal_ingredients",
              partial: "food/meals/ingredients",
              locals: { meal: @meal, new_ingredient: @new_ingredient }
            ), status: status
          end
          format.html { redirect_to food_meal_path(@meal), notice: notice }
        end
      end
  end
end
