require 'will_paginate/view_helpers/link_renderer'
require 'will_paginate/view_helpers/action_view'

class CustomPaginateRenderer < ::WillPaginate::ActionView::LinkRenderer
  protected

  def page_number(page)
    if page == current_page
      tag(:li, tag(:span, page, class: 'page-link'), class: 'page-item active')
    else
      tag(:li, link(page, page, class: 'page-link', rel: rel_value(page)), class: 'page-item')
    end
  end
  def previous_or_next_page(page, text, classname)
    disabled_class = page ? "" : "disabled"
    tag(:li, link(text , page || '#', class: "page-link"), class: "page-item #{classname} #{disabled_class}")
  end

  def html_container(html)
    tag(:ul, html , container_attributes)
  end
end
