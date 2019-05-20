class EventsRemoveActiveColumn < ActiveRecord::Migration[5.2]
  def change
  	remove_column :events, :active, :boolean, null: false, default: true
  end
end
