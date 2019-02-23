class PagesController < ApplicationController
  def index
    @events = Event.to_happen
  end
end
