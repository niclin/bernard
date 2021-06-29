require 'rest-client'

class PunchWorker
  include Notifier::SlackNotifiable

  sidekiq_options retry: false
  sidekiq_options unique: :until_and_while_executing

  HR_SYSTEM_URL = "https://chr.ecmaker.com/servlet/jform".freeze
  FORM_FILE = "hrm8airw.pkg;hrm_1749486007995236467020778061283968299909.cfg,hrm8w.pkg,briefcase.pkg,hrm8aw.pkg,hrm8bw.pkg,hrm8fw.pkg".freeze

  def perform
    PunchSchedule.pending.where(schedule_at_unixtime: (Time.zone.now - 1.minutes).to_i..(Time.zone.now + 1.minutes).to_i, time_line: time_line).find_each do |punch_schedule|
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
    table_data = punch_setting.geo_disable? ? '{}' : "{'latitude':#{punch_setting.geo_latitude},'longitude':#{punch_setting.geo_longitude}}"

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
        table_data: table_data,
        file: FORM_FILE,
      },
      {
        cookies: cookies_object
      }
    )

    return_value = Hash.from_xml(punch_response.body)["root"]["return_value"]

    punch_result = JSON.parse(return_value)

    if punch_result["status"] == "success"
      punch_schedule.update!(
        status: "successed",
        perform_at_unixtime: Time.zone.now.to_i,
        response: punch_result["message"]
      )
      attachments = build_attachment(punch_schedule)
    else
      punch_schedule.update!(
        status: "failed",
        perform_at_unixtime: Time.zone.now.to_i,
        response: punch_response
      )
      attachments = build_attachment(punch_schedule)
    end
    send_to_slack(WEST_WORLD, "Bernard Bot", nil, attachments)
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
    target_time_range = (punch_schedule.schedule_at_unixtime - 1.minute.to_i)..(punch_schedule.schedule_at_unixtime + 1.minute.to_i)

    perform_at.to_i.in?(target_time_range)
  end

  def build_attachment(source)
    check_point_message = now_is_morning? ? "打卡上班" : "打卡下班"
    message = source.successed? ? "#{source.user.email} 已#{check_point_message}" : "#{source.user.email} #{check_point_message}失敗"
    error_message = source.successed? ? "" : "\n*Response：*#{source.response}"
    priority = source.successed? ? "success" : "alert"
    [{
       "type": "mrkdwn",
       "color": SLACK_COLOR.public_send(priority),
       "text": "*訊息：* `#{message}`#{error_message}",
       "footer": "WestWorld(1973)",
       "ts": source.perform_at_unixtime.to_i
    }]
  end
end
