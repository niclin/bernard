class GeneratePrepunchWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options unique: :until_and_while_executing

  def perform
    PunchSetting.enable.find_each do |punch_setting|

      today = Date.today
      user = punch_setting.user

      # AM
      if !user.punch_schedules.where(date: today, time_line: "AM").exists?
        start_work_time_padding_munutes = random_minutes_with_number(punch_setting.start_work_padding_percentage)
        morning_schedule_at = Time.strptime(punch_setting.start_work_time, '%H%M') + start_work_time_padding_munutes

        PunchSchedule.create!(
          user: user,
          time_line: "AM",
          date: today,
          schedule_at_unixtime: morning_schedule_at.to_i,
          status: "pending"
        )
      end

      # PM
      if !user.punch_schedules.where(date: today, time_line: "PM").exists?
        end_work_time_padding_munutes = random_minutes_with_number(punch_setting.end_work_padding_percentage)
        afternoon_schedule_at = Time.strptime(punch_setting.end_work_time, '%H%M') + end_work_time_padding_munutes

        PunchSchedule.create!(
          user: punch_setting.user,
          time_line: "PM",
          date: today,
          schedule_at_unixtime: afternoon_schedule_at.to_i,
          status: "pending"
        )
      end
    end
  end

  private

  def random_minutes_with_number(number)
    number_range = number.negative? ? (number..0) : (0..number)

    rand(number_range).minutes
  end
end