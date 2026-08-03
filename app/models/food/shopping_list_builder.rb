module Food
  # Builds (or rebuilds) a shopping list from a weekly plan's planned meals.
  # Ingredients are grouped by name + unit; matching ingredients have their
  # quantities summed, while different units stay on separate rows. Kept simple
  # on purpose — no unit conversion in v1.
  class ShoppingListBuilder
    def initialize(weekly_plan)
      @weekly_plan = weekly_plan
      @user = weekly_plan.user
    end

    def build!
      list = find_or_create_list
      list.transaction do
        list.shopping_list_items.destroy_all
        grouped_ingredients.each_value do |group|
          item = group[:shopping_item]
          list.shopping_list_items.create!(
            user: @user,
            shopping_item: item,
            store_id: item&.store_id,
            name: group[:name],
            unit: group[:unit],
            quantity: group[:quantity],
            estimated_unit_price_cents: item&.estimated_unit_price_cents
          )
        end
      end
      list
    end

    private
      def find_or_create_list
        @weekly_plan.shopping_lists.order(:created_at).first ||
          @user.shopping_lists.create!(
            weekly_plan: @weekly_plan,
            name: "Week of #{@weekly_plan.starts_on.strftime('%-d %b')}",
            status: :active
          )
      end

      # Returns { [name, unit] => { name:, unit:, quantity:, shopping_item: } }.
      def grouped_ingredients
        groups = {}
        planned_meals = @weekly_plan.planned_meals.includes(meal: { meal_ingredients: :shopping_item })

        planned_meals.each do |planned_meal|
          next unless planned_meal.meal

          planned_meal.meal.meal_ingredients.each do |ingredient|
            key = [ ingredient.name.to_s.strip.downcase, ingredient.unit.to_s.strip.downcase ]
            group = groups[key] ||= {
              name: ingredient.name, unit: ingredient.unit,
              quantity: nil, shopping_item: ingredient.shopping_item
            }
            group[:quantity] = group[:quantity].to_d + ingredient.quantity if ingredient.quantity
            group[:shopping_item] ||= ingredient.shopping_item
          end
        end

        groups
      end
  end
end
