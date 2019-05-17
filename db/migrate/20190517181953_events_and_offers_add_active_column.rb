class EventsAndOffersAddActiveColumn < ActiveRecord::Migration[5.2]
  def change
  	add_column :events, :active, :boolean, null: false, default: true
  	add_column :offers, :active, :boolean, null: false, default: true
  end
end
