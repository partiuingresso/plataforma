if Rails.env.development?
  return
else
  ActionMailer::Base.smtp_settings = {
    :user_name => 'apikey',
    :password => Rails.application.credentials.sendgrid_api_key,
    :domain => 'partiuingresso.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
  }
end