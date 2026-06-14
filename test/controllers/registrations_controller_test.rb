require "test_helper"

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "new is accessible without authentication" do
    get new_registration_path
    assert_response :success
  end

  test "creates a user and signs them in" do
    assert_difference -> { User.count }, 1 do
      post registration_path, params: {
        user: {
          email_address: "new@example.com",
          name: "New Person",
          password: "secret123",
          password_confirmation: "secret123",
          week_starts_on: "monday"
        }
      }
    end
    assert_redirected_to root_path
    follow_redirect!
    assert_response :success
  end

  test "rejects mismatched password confirmation" do
    assert_no_difference -> { User.count } do
      post registration_path, params: {
        user: {
          email_address: "bad@example.com",
          password: "secret123",
          password_confirmation: "nope"
        }
      }
    end
    assert_response :unprocessable_entity
  end
end
