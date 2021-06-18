class GeneratePrepunchWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options unique: :until_and_while_executing

  def perform
    PunchSetting.enable.find_each do |punch_setting|

      today = Date.today

      # AM
      start_work_time_padding_munutes = rand(0..punch_setting.start_work_padding_percentage).minutes
      morning_schedule_at = Time.strptime(punch_setting.start_work_time, '%H%M') + start_work_time_padding_munutes

      PunchSchedule.create!(
        user: punch_setting.user,
        time_line: "AM",
        date: today,
        schedule_at: morning_schedule_at,
        status: "pending"
      )

      # PM
      end_work_time_padding_munutes = rand(0..punch_setting.end_work_padding_percentage).minutes
      afternoon_schedule_at = Time.strptime(punch_setting.end_work_time, '%H%M') + end_work_time_padding_munutes

      PunchSchedule.create!(
        user: punch_setting.user,
        time_line: "AM",
        date: today,
        schedule_at: afternoon_schedule_at,
        status: "pending"
      )
    end
  end
end