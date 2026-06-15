module Shopping
  class ShoppingItemsController < ApplicationController
    before_action :set_shopping_item, only: %i[edit update destroy]

    def index
      @shopping_items = Current.user.shopping_items.ordered
    end

    def new
      @shopping_item = Current.user.shopping_items.new(active: true)
    end

    def create
      @shopping_item = Current.user.shopping_items.new(shopping_item_params)

      if @shopping_item.save
        redirect_to shopping_shopping_items_path, notice: "Item added to your library."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @shopping_item.update(shopping_item_params)
        redirect_to shopping_shopping_items_path, notice: "Item updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shopping_item.destroy!
      redirect_to shopping_shopping_items_path, notice: "Item removed.", status: :see_other
    end

    private
      def set_shopping_item
        @shopping_item = Current.user.shopping_items.find(params[:id])
      end

      def shopping_item_params
        params.require(:shopping_item).permit(
          :name, :category, :store_id, :default_quantity, :default_unit,
          :estimated_unit_price, :notes, :active
        ).tap do |attrs|
          price = attrs.delete(:estimated_unit_price)
          attrs[:estimated_unit_price_cents] = to_cents(price) if price
        end
      end

      def to_cents(value)
        return nil if value.blank?

        (value.to_d * 100).round
      end
  end
end
