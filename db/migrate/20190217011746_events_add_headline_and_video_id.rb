class EventsAddHeadlineAndVideoId < ActiveRecord::Migration[5.2]
  def change
  	add_column :events, :headline, :string
  	add_column :events, :video, :string
  end
end
