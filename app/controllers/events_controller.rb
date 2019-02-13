class EventsController < ApplicationController
	def index
		@events = Event.where(company: current_user.company)
	end
end
