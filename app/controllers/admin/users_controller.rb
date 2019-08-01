class Admin::UsersController < ApplicationController
	authorize_resource

	def index
		if search_params[:q].present?
			@all_users = User.all.order(created_at: :desc)
			@search_user = @all_users.search_user(search_params[:q])
			@users = Kaminari.paginate_array(@search_user).page(params[:page]).per(10)
		else
			@all_users = User.where(created_at: Time.current.beginning_of_month..Time.current.end_of_month).order(created_at: :desc)
			@users = Kaminari.paginate_array(@all_users).page(params[:page]).per(10)
		end
	end

	private
	
		def search_params
			params.permit(:q)
		end

		def current_ability
			@current_ability ||= AdminAbility.new(current_user)
		end
end
