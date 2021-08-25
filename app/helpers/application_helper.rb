module ApplicationHelper
  def render_perform_at_time_string(unixtime)
    return if unixtime.blank?

    Time.zone.at(unixtime)
  end

  # 這個月有幾天
  def this_month_days
    days = [nil, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
    year = Time.zone.now.year
    month = Time.zone.now.month
    return 29 if month == 2 && Date.gregorian_leap?(year)
    days[month]
  end
end
