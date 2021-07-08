module PunchSettingsHelper

  def render_timeline_badge(time_line)
    klass = time_line == "AM" ? "badge bg-info" : "badge bg-warning text-dark"
    tag.span(time_line, class: klass)
  end

  def render_status(punch_schedule)
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
end
