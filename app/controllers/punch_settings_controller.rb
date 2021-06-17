class PunchSettingsController < ApplicationController
  before_action :authenticate_user!

  def new
    @punch_setting = current_user.build_punch_setting
  end

  def create
    @punch_setting = current_user.build_punch_setting(punch_setting_params)

    if @punch_setting.save
      redirect_to punch_setting_path
    else
      render :new
    end
  end

  def edit
    @punch_setting = current_user.punch_setting
  end

  def update
    @punch_setting = current_user.punch_setting

    if @punch_setting.update(punch_setting_params)
      redirect_to punch_setting_path
    else
      render :edit
    end
  end

  def show
    @punch_setting = current_user.punch_setting
    @punch_histories = current_user.punch_histories
  end

  private

  def punch_setting_params
    params.require(:punch_setting).permit(:uid, :id_serial, :start_work_time, :start_work_padding_percentage, :end_work_time, :end_work_padding_percentage, :status)
  end
end
