class SettingsController < ApplicationController
  before_action :set_user

  def show
  end

  def edit
  end

  def update
    if @user.update(settings_params)
      redirect_to settings_path, notice: "Settings saved."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_user
      @user = Current.user
    end

    def settings_params
      params.require(:user).permit(:name, :time_zone, :week_starts_on)
    end
end
