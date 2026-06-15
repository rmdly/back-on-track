require "test_helper"

module Shopping
  class ShoppingListsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:one)
      @other = users(:two)
      sign_in_as(@user)
    end

    test "requires authentication" do
      sign_out
      get shopping_shopping_lists_path
      assert_redirected_to new_session_path
    end

    test "index shows the user's lists" do
      @user.shopping_lists.create!(name: "My shop")
      get shopping_shopping_lists_path
      assert_response :success
      assert_match "My shop", response.body
    end

    test "create makes a list with a budget in cents" do
      assert_difference -> { @user.shopping_lists.count }, 1 do
        post shopping_shopping_lists_path, params: { shopping_list: { name: "Weekly", budget: "40.00" } }
      end
      list = @user.shopping_lists.order(:created_at).last
      assert_equal 4000, list.budget_cents
      assert_redirected_to shopping_shopping_list_path(list)
    end

    test "create is invalid without a name" do
      assert_no_difference -> { @user.shopping_lists.count } do
        post shopping_shopping_lists_path, params: { shopping_list: { name: "" } }
      end
      assert_response :unprocessable_entity
    end

    test "cannot view another user's list" do
      others = @other.shopping_lists.create!(name: "Theirs")
      get shopping_shopping_list_path(others)
      assert_response :not_found
    end
  end
end
