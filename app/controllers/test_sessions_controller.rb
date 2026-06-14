# Test-only helper to sign a user in without driving the login form, so that
# system tests for other features aren't coupled to (or flaked by) the auth UI.
# The route is mounted only in the test environment (see config/routes.rb), so
# this is unreachable in development and production.
class TestSessionsController < ApplicationController
  allow_unauthenticated_access only: :create

  def create
    user = User.find(params[:user_id])
    start_new_session_for(user)
    redirect_to root_path
  end
end
