class EventsRemoveImageUrl < ActiveRecord::Migration[5.2]
  def change
  	remove_column :events, :image_url, :string
  end
end
