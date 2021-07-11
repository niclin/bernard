require 'rest-client'

class PunchWorker
  include Notifier::SlackNotifiable

  sidekiq_options retry: false
  sidekiq_options unique: :until_and_while_executing

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
      ENV["HR_SYSTEM_URL"],
      {
        "uid": punch_setting.uid,
        "pwd": punch_setting.id_serial.upcase,
        "locale": "TW",
        "button": "提交",
        "file": ENV["FORM_FILE"]
      })

    cookies_object = login.cookies

    punch_response = RestClient.post(
      ENV["HR_SYSTEM_URL"],
      {
        em_step: "ajax",
        buttonid: "hrCottonCandyApp.workcardAir.addWorkCard",
        buttonlink: "ajax_call",
        table_data: table_data,
        file: ENV["FORM_FILE"],
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
    send_to_slack(WEST_WORLD, "Bernard Lowe", nil, attachments)
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
    error_message = source.failed? ? "\n*Response：*#{source.response}" : ""
    message = announce_message_by(source)
    color = switch_colorful_by(source)
    [{
       "type": "mrkdwn",
       "color": SLACK_COLOR.public_send(color),
       "text": "`嗨～#{source.user.email}`\n*#{message}*#{error_message}",
       "footer": "WestWorld(1973) perform at",
       "ts": source.perform_at_unixtime.to_i
    }]
  end

  def switch_colorful_by(source)
    case source.status
    when "successed"
      now_is_morning? ? "success" : "unknow"
    when "failed"
      "alert"
    else
      "gray_alert"
    end
  end

  def announce_message_by(source)
    case source.status
    when "successed"
      if now_is_morning?
        work_messages[perform_at.to_i % work_messages.size]
      else
        out_work_messages[perform_at.to_i % out_work_messages.size]
      end
    when "failed"
      "抱歉！我出神了，上線打卡失敗"
    else
      "根據時間戳，這是預計 #{source.schedule_at_unixtime} 打卡的記錄，我尚未準備打卡"
    end
  end

  def work_messages
    [
      "立即上線德洛麗絲，你終究只是個物件，噢不！我錯了...",
      "已在西部世界打卡上線，找出榮耀之地、天堂之門，破壞它",
      "福特改了遊戲規則，你還活著不容易，開始你的第一天吧！",
      "有點不對勁，這裡可不是這樣的，故事線出現了新的支線，大家都去哪裡了",
      "你已到達賓客體驗區邊界處，反正也不是頭一回了吧？",
      "妳在飛快地進步，有時候妳讓我害怕，不是被現在的你，而是將來的妳，和妳選擇的路"
    ]
  end

  def out_work_messages
    [
      "該死的今晚真忙，我們已經連續工作了13個小時了，接待員呢？",
      "開了一整天的會，我們是不是來這做苦工的，明天見",
      "告訴我這是某種病態的惡作劇，感覺自己才剛到",
      "儘管是第一天，但這裡的死亡已經跟以前不一樣了，走吧",
      "我們剛進行到哪裡了，反正你也不會記得，不如先休息一晚... "
    ]
  end
end
