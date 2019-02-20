module ApplicationHelper

  def link_to_in_li(body, url, html_options = {})
    active = "is-active" if current_page?(url)
    html_options = {class: active}
    link_to body, url, html_options
  end

  def value_to_currency(value)
		integer_value = (value.to_i).to_s
		decimal_value = ((value % 1).to_i).to_s

		"R$" + integer_value + "," + decimal_value
	end

end
