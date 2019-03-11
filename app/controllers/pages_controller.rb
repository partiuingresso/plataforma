class PagesController < ApplicationController
  def index
    @events = Event.to_happen
  end

  def search
    @events = Event.search_by_name(params[:q])
  end
end
