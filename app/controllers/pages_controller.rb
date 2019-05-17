class PagesController < ApplicationController
  def index
    @events = Event.order(created_at: :desc).available
  end

  def search
    @events = Event.search_by_name(params[:q])
  end
end
