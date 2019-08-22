class EventsAddMarketingIntegrations < ActiveRecord::Migration[5.2]
  def change
  	add_column :events, :fb_pixel, :string
  	add_column :events, :ga_id, :string
  end
end
