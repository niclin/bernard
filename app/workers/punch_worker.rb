require 'rest-client'

class PunchWorker
  include Sidekiq::Worker

  sidekiq_options retry: false
  sidekiq_options unique: :until_and_while_executing

  HR_SYSTEM_URL = "https://chr.ecmaker.com/servlet/jform".freeze
  FORM_FILE = "hrm8airw.pkg;hrm_1749486007995236467020778061283968299909.cfg,hrm8w.pkg,briefcase.pkg,hrm8aw.pkg,hrm8bw.pkg,hrm8fw.pkg".freeze

  def perform
    PunchSchedule.pending.where(schedule_at_unixtime: 1.minute.ago.to_i..1.minute.from_now.to_i, time_line: time_line).find_each do |punch_schedule|
      if in_safe_time_range?(punch_schedule) && !punch_schedule.user.alreday_punch_today?(time_line: time_line)
        punch!(punch_schedule)
      else
        puts "ID: #{punch_schedule.id} 目前不需要打卡, 時間區域: #{in_safe_time_range?(punch_schedule)}, 該時段 #{time_line} 打卡狀態: #{punch_schedule.user.alreday_punch_today?(time_line: time_line)}"
      end
    end
  end

  private

  def punch!(punch_schedule)
    punch_setting = punch_schedule.user.punch_setting

    login = RestClient.post(
      HR_SYSTEM_URL,
      {
        "uid": punch_setting.uid,
        "pwd": punch_setting.id_serial.upcase,
        "locale": "TW",
        "button": "提交",
        "file": FORM_FILE
      })

    cookies_object = login.cookies

    punch_response = RestClient.post(
      HR_SYSTEM_URL,
      {
        em_step: "ajax",
        buttonid: "hrCottonCandyApp.workcardAir.addWorkCard",
        buttonlink: "ajax_call",
        table_data: "{}",
        file: FORM_FILE,
      },
      {
        cookies: cookies_object
      }
    )

    return_value = Hash.from_xml(punch_response.body)["root"]["return_value"]

    punch_result = JSON.parse(return_value)

    if punch_result["status"] == "success"
      punch_schedule.update(
        status: "successed",
        perform_at_unixtime: Time.zone.now.to_i,
        response: punch_result["message"]
      )
    else
      punch_schedule.update(
        status: "failed",
        perform_at_unixtime: Time.zone.now.to_i,
        response: punch_response
      )
    end
  end

  def perform_at
    @perform_at ||= Time.zone.now
  end

  def now_is_morning?
    time_line == "AM"
  end

  def time_line
    @time_line ||= perform_at.strftime("%p")
  end

  def in_safe_time_range?(punch_schedule)
    target_time_range = (punch_schedule.schedule_at_unixtime - 1.minute).to_i..(punch_schedule.schedule_at_unixtime + 1.minute).to_i

    perform_at.to_i.in?(target_time_range)
  end
end