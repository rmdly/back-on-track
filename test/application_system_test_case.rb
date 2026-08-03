require "test_helper"

Capybara.enable_aria_label = true
Capybara.default_max_wait_time = 10

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome, screen_size: [ 400, 900 ]

  # Sign a user in deterministically via a test-only endpoint, avoiding flakiness
  # from driving the auth form (the form itself is covered by controller tests).
  def sign_in_as(user)
    visit test_sign_in_path(user)
    assert_selector "h1", text: "Today"
  end
end
