require "application_system_test_case"

class ShoppingTest < ApplicationSystemTestCase
  setup { @user = users(:one) }

  test "user can create a list, add an item, and mark it bought" do
    sign_in_as @user

    click_on "Shopping"
    assert_selector "h1", text: "Shopping lists"
    click_on "New list"

    assert_selector "h1", text: "New shopping list"
    fill_in "Name", with: "Weekly shop"
    fill_in "Budget £", with: "40"
    click_on "Create list"

    assert_selector "h1", text: "Weekly shop"

    fill_in "Item name", with: "Chicken breast"
    fill_in "£ each", with: "5.49"
    click_on "Add"

    assert_text "Chicken breast"
    assert_text "0 of 1 bought"

    click_button "Mark Chicken breast bought"
    assert_text "1 of 1 bought"
    assert_text "100%"
  end

  test "over budget is flagged" do
    list = @user.shopping_lists.create!(name: "Tight budget", budget_cents: 100)
    list.shopping_list_items.create!(user: @user, name: "Steak", estimated_unit_price_cents: 999)

    sign_in_as @user
    visit shopping_shopping_list_path(list)
    assert_text "Over budget"
  end
end
