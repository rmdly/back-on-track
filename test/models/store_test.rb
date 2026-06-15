require "test_helper"

class StoreTest < ActiveSupport::TestCase
  setup { @user = users(:one) }

  test "requires a name" do
    assert_not @user.stores.new(name: nil).valid?
  end

  test "name is unique per user, case-insensitively" do
    @user.stores.create!(name: "Aldi")
    duplicate = @user.stores.new(name: "aldi")
    assert_not duplicate.valid?
  end

  test "the same store name is allowed for different users" do
    @user.stores.create!(name: "Aldi")
    other = users(:two).stores.new(name: "Aldi")
    assert other.valid?
  end
end
