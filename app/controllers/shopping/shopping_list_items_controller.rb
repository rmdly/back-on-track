module Shopping
  class ShoppingListItemsController < ApplicationController
    before_action :set_shopping_list, only: :create
    before_action :set_shopping_list_item, only: %i[edit update destroy buy unbuy]

    def create
      @shopping_list_item = @shopping_list.shopping_list_items.new(shopping_list_item_params)
      @shopping_list_item.user = Current.user
      apply_library_snapshot

      if @shopping_list_item.save
        respond_with_list
      else
        respond_with_list(status: :unprocessable_entity)
      end
    end

    def edit
    end

    def update
      if @shopping_list_item.update(shopping_list_item_params)
        redirect_to shopping_shopping_list_path(@shopping_list), notice: "Item updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @shopping_list_item.destroy!
      respond_with_list(notice: "Item removed.")
    end

    def buy
      @shopping_list_item.mark_bought!
      respond_with_list
    end

    def unbuy
      @shopping_list_item.mark_unbought!
      respond_with_list
    end

    private
      def set_shopping_list
        @shopping_list = Current.user.shopping_lists.find(params[:shopping_list_id])
      end

      def set_shopping_list_item
        @shopping_list_item = Current.user.shopping_list_items.find(params[:id])
        @shopping_list = @shopping_list_item.shopping_list
      end

      def shopping_list_item_params
        permitted = params.require(:shopping_list_item).permit(
          :name, :shopping_item_id, :store_id, :quantity, :unit, :notes, :estimated_unit_price
        )
        if permitted.key?(:estimated_unit_price)
          price = permitted.delete(:estimated_unit_price)
          permitted[:estimated_unit_price_cents] = price.present? ? (price.to_d * 100).round : nil
        end
        permitted
      end

      # When an item is chosen from the library, snapshot its details onto the
      # list item so the list stays meaningful even if the library item changes.
      def apply_library_snapshot
        library_item = Current.user.shopping_items.find_by(id: @shopping_list_item.shopping_item_id)
        return unless library_item

        @shopping_list_item.name = library_item.name if @shopping_list_item.name.blank?
        @shopping_list_item.unit ||= library_item.default_unit
        @shopping_list_item.quantity ||= library_item.default_quantity
        @shopping_list_item.estimated_unit_price_cents ||= library_item.estimated_unit_price_cents
        @shopping_list_item.store_id ||= library_item.store_id
      end

      def respond_with_list(notice: nil, status: :ok)
        @shopping_list.reload
        @new_item = ShoppingListItem.new
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "shopping_list_body",
              partial: "shopping/shopping_lists/list_body",
              locals: { shopping_list: @shopping_list, new_item: @new_item }
            ), status: status
          end
          format.html { redirect_to shopping_shopping_list_path(@shopping_list), notice: notice }
        end
      end
  end
end
