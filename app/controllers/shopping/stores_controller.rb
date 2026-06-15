module Shopping
  class StoresController < ApplicationController
    before_action :set_store, only: %i[edit update destroy]

    def index
      @stores = Current.user.stores.ordered
    end

    def new
      @store = Current.user.stores.new(active: true)
    end

    def create
      @store = Current.user.stores.new(store_params)

      if @store.save
        redirect_to shopping_stores_path, notice: "Store added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @store.update(store_params)
        redirect_to shopping_stores_path, notice: "Store updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @store.destroy!
      redirect_to shopping_stores_path, notice: "Store removed.", status: :see_other
    end

    private
      def set_store
        @store = Current.user.stores.find(params[:id])
      end

      def store_params
        params.require(:store).permit(:name, :position, :active)
      end
  end
end
