require "test_helper"

class ShoppingListItemTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @list = @user.shopping_lists.create!(name: "Weekly shop")
    @item = @list.shopping_list_items.create!(user: @user, name: "Rice",
                                              estimated_unit_price_cents: 175, quantity: 2)
  end

  test "new item is not bought" do
    assert_not @item.bought?
  end

  test "mark_bought! and mark_unbought! toggle state" do
    @item.mark_bought!
    assert @item.bought?
    assert @item.bought_at.present?

    @item.mark_unbought!
    assert_not @item.bought?
    assert_nil @item.bought_at
  end

  test "estimated_total_cents is price times quantity" do
    assert_equal 350, @item.estimated_total_cents
  end

  test "estimated_total_cents defaults quantity to one" do
    item = @list.shopping_list_items.create!(user: @user, name: "Milk", estimated_unit_price_cents: 125)
    assert_equal 125, item.estimated_total_cents
  end

  test "estimated_total_cents is zero without a price" do
    item = @list.shopping_list_items.create!(user: @user, name: "Free", quantity: 3)
    assert_equal 0, item.estimated_total_cents
  end

  test "requires a name" do
    item = @list.shopping_list_items.new(user: @user, name: nil)
    assert_not item.valid?
  end
end
