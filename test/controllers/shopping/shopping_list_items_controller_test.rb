require "test_helper"

module Shopping
  class ShoppingListItemsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
      @list = @user.shopping_lists.create!(name: "Weekly shop")
    end

    test "create adds an item with a price in cents" do
      assert_difference -> { @list.shopping_list_items.count }, 1 do
        post shopping_shopping_list_shopping_list_items_path(@list),
          params: { shopping_list_item: { name: "Rice", quantity: "2", unit: "kg", estimated_unit_price: "1.75" } }
      end
      item = @list.shopping_list_items.order(:created_at).last
      assert_equal 175, item.estimated_unit_price_cents
      assert_equal 350, item.estimated_total_cents
    end

    test "create from a library item snapshots its details" do
      library = @user.shopping_items.create!(name: "Oats", default_unit: "kg",
                                             default_quantity: 1, estimated_unit_price_cents: 135)
      post shopping_shopping_list_shopping_list_items_path(@list),
        params: { shopping_list_item: { shopping_item_id: library.id } }
      item = @list.shopping_list_items.order(:created_at).last
      assert_equal "Oats", item.name
      assert_equal "kg", item.unit
      assert_equal 135, item.estimated_unit_price_cents
    end

    test "buy and unbuy toggle bought state" do
      item = @list.shopping_list_items.create!(user: @user, name: "Eggs")
      patch buy_shopping_shopping_list_item_path(item)
      assert item.reload.bought?
      patch unbuy_shopping_shopping_list_item_path(item)
      assert_not item.reload.bought?
    end

    test "cannot buy another user's item" do
      others_list = @other.shopping_lists.create!(name: "Theirs")
      others_item = others_list.shopping_list_items.create!(user: @other, name: "Secret")
      patch buy_shopping_shopping_list_item_path(others_item)
      assert_response :not_found
      assert_not others_item.reload.bought?
    end
  end
end
