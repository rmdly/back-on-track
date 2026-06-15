require "test_helper"

class ShoppingListTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @list = @user.shopping_lists.create!(name: "Weekly shop", budget_cents: 4000)
  end

  def add_item(price_cents:, quantity: 1, bought: false)
    item = @list.shopping_list_items.create!(
      user: @user, name: "Item", estimated_unit_price_cents: price_cents, quantity: quantity
    )
    item.mark_bought! if bought
    item
  end

  test "estimated_total_cents sums price times quantity across items" do
    add_item(price_cents: 500, quantity: 2) # 1000
    add_item(price_cents: 150, quantity: 1) # 150
    assert_equal 1150, @list.reload.estimated_total_cents
  end

  test "items without a price contribute zero" do
    add_item(price_cents: nil)
    add_item(price_cents: 200)
    assert_equal 200, @list.reload.estimated_total_cents
  end

  test "bought_total and remaining_total reflect bought state" do
    add_item(price_cents: 500, bought: true)
    add_item(price_cents: 300, bought: false)
    @list.reload
    assert_equal 500, @list.bought_total_cents
    assert_equal 300, @list.remaining_total_cents
  end

  test "over_budget? is true only when estimate exceeds budget" do
    add_item(price_cents: 3000)
    assert_not @list.reload.over_budget?

    add_item(price_cents: 1500) # total 4500 > 4000
    assert @list.reload.over_budget?
  end

  test "over_budget? is false when no budget set" do
    list = @user.shopping_lists.create!(name: "No budget")
    list.shopping_list_items.create!(user: @user, name: "x", estimated_unit_price_cents: 9999)
    assert_not list.reload.over_budget?
  end

  test "progress_percentage tracks bought items" do
    add_item(price_cents: 100, bought: true)
    add_item(price_cents: 100, bought: false)
    assert_equal 50, @list.reload.progress_percentage
  end
end
