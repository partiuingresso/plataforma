class ApplicationController < ActionController::Base
  require "browser/aliases"
  Browser::Base.include(Browser::Aliases)
	prepend_view_path Rails.root.join("app", "frontend", "views")
	add_flash_types :success, :danger, :info
	rescue_from CanCan::AccessDenied do |exception|
		respond_to do |format|
			format.json { head :forbidden, content_type: 'text/html' }
			format.html { redirect_to main_app.root_url, alert: exception.message }
			format.js   { head :forbidden, content_type: 'text/html' }
		end
	end
end
