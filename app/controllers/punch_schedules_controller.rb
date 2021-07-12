class PunchSchedulesController < ApplicationController
  def destroy
    punch_schedule = PunchSchedule.find(params[:id])
    punch_schedule.cancel!
    redirect_to punch_setting_path
  end
end
