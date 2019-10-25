class PagesController < ApplicationController

  def index
    @highlights = Event.highlights
    @events = Event.order(created_at: :desc).to_happen - @highlights
    if browser.mobile?
      render "index_mobile"
    else
      # @user_location = request.location
      render "index"
    end
  end

  def search
    @events = Event.search_by_name(params[:q])
  end
end
