class ApplicationMailer < ActionMailer::Base
	append_view_path Rails.root.join("app", "frontend", "views")
  default from: '"PartiuIngresso.com" <noreply@partiuingresso.com>'
  layout 'mailer'
end
