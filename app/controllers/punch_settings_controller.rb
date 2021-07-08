class PunchSettingsController < ApplicationController
  layout "dashboard"

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
    @punch_schedules = current_user.punch_schedules.order(id: :desc)
  end

  def cancel_schedule
    punch_schedule = PunchSchedule.find(params[:id])
    punch_schedule.cancel!
    redirect_to punch_setting_path
  rescue StrandardError => e
    redirect_to punch_setting_path
  end

  private

  def punch_setting_params
    params.require(:punch_setting).permit(:uid, :id_serial, :start_work_time, :start_work_padding_percentage, :end_work_time, :end_work_padding_percentage, :status, :geo_latitude, :geo_longitude, :geo_status)
  end
end
