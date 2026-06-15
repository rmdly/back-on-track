module Shopping
  class ShoppingListsController < ApplicationController
    before_action :set_shopping_list, only: %i[show edit update destroy]

    def index
      @shopping_lists = Current.user.shopping_lists.ordered
    end

    def show
      @new_item = ShoppingListItem.new
    end

    def new
      @shopping_list = Current.user.shopping_lists.new(status: :draft, planned_on: Date.current)
    end

    def create
      @shopping_list = Current.user.shopping_lists.new(shopping_list_params)

      if @shopping_list.save
        redirect_to shopping_shopping_list_path(@shopping_list), notice: "Shopping list created."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @shopping_list.update(shopping_list_params)
        redirect_to shopping_shopping_list_path(@shopping_list), notice: "Shopping list updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shopping_list.destroy!
      redirect_to shopping_shopping_lists_path, notice: "Shopping list deleted.", status: :see_other
    end

    private
      def set_shopping_list
        @shopping_list = Current.user.shopping_lists.find(params[:id])
      end

      def shopping_list_params
        permitted = params.require(:shopping_list).permit(
          :name, :store_id, :status, :planned_on, :starts_on, :ends_on, :notes,
          :show_quantity, :show_unit, :show_price, :show_store, :budget
        )
        if permitted.key?(:budget)
          budget = permitted.delete(:budget)
          permitted[:budget_cents] = budget.present? ? (budget.to_d * 100).round : nil
        end
        permitted
      end
  end
end
