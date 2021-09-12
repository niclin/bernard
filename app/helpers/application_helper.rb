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

  # 這個月有幾天工作日
  # gem business_time
  # 新增特殊假日於 config/business_time.yml
  def this_month_business_days(month_number)
    first_month = Date::MONTHNAMES[month_number.to_i]
    next_month = Date::MONTHNAMES[month_number.to_i + 1]
    first_date = Date.parse(month_name)
    next_date = Date.parse(next_month)
    first_date.business_days_until(next_date)
  end
end
