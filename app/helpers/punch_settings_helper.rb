module PunchSettingsHelper
  # 早晚標籤
  def render_timeline_badge(time_line)
    klass = time_line == "AM" ? "badge bg-info" : "badge bg-warning text-dark"
    tag.span(time_line, class: klass)
  end

  # 執行結果標籤
  def render_status_tag(punch_schedule)
    klass = case punch_schedule.status
            when "successed"
              "badge bg-success"
            when "failed"
              "badge bg-danger"
            when "cancel"
              "badge bg-warning"
            else
              "badge bg-secondary"
            end
    tag.span(I18n.t("enum.punch_schedule.status.#{punch_schedule.status}"), class: klass)
  end

  # 開關狀態標籤
  def render_state_class(status)
    klass = case status
            when 0
              "badge bg-danger"
            when 1
              "badge bg-success"
            end
  end

  # 壓縮時間，方便畫線(2021/09/12 -> 912)
  def render_compression_time_array(punch_schedules)
    time_array = punch_schedules.pluck(:perform_at_unixtime)
    min_time_array = time_array.map do |time|
      return 0 if time.blank?
      (Time.zone.at(time).strftime("%H") + Time.zone.at(time).strftime("%M")).to_i
    end

    min_time_array.to_s.html_safe
  end

  # 平均上下班於
  def render_time_average(punch_schedules)
    time_array = punch_schedules.pluck(:perform_at_unixtime)
    hour_array = time_array.map do |time|
      Time.zone.at(time).strftime("%H").to_i
    end
    sec_array = time_array.map do |time|
      Time.zone.at(time).strftime("%M").to_i
    end

    hour_text = (hour_array.sum / punch_schedules.size).to_s.rjust(2, "0")
    sec_text = (sec_array.sum / punch_schedules.size).to_s.rjust(2, "0")

    "#{hour_text}:#{sec_text}"
  end

  # 日期陣列
  def render_date_array(punch_schedules)
    perform_at_array = punch_schedules.pluck(:perform_at_unixtime)
    array = []
    perform_at_array.sort.each do |unixtime|
      array << Time.at(unixtime).strftime("%m/%d").to_s
    end
    array.to_s.html_safe
  end

  def render_this_month_daka_percentage(punch_schedules)
    punch_schedules.size * 100  / this_month_business_days
  end
end
