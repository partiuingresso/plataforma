module ApplicationHelper

  def link_to_in_li(body, url, html_options = {})
    active = "is-active" if current_page?(url)
    html_options = {class: active}
    link_to body, url, html_options
  end

end
