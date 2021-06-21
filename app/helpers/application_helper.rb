module ApplicationHelper
  def render_perform_at_time_string(unixtime)
    return if unixtime.blank?

    Time.zone.at(unixtime)
  end
end
