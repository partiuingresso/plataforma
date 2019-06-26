class PagesController < ApplicationController
  def index
    @nextEvents = Event.where(start_t: 12.hours.ago..15.days.from_now)
    @events = Event.order(created_at: :desc).to_happen - @nextEvents
  end

  def search
    @events = Event.search_by_name(params[:q])
  end
end
