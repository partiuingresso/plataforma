class DeviseMailer < Devise::Mailer
	prepend_view_path Rails.root.join("app", "frontend", "views")
end