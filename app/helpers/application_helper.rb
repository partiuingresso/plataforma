module ApplicationHelper

  def link_to_in_li(body, url, html_options = {})
    active = "is-active" if current_page?(url)
    html_options = {class: active}
    link_to body, url, html_options
  end

  def value_to_currency(value)
		value_string = "%.2f" % value
		value_string.sub ".", ","
	end

end
