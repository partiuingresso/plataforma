class EventsAddAdsColumns < ActiveRecord::Migration[5.2]
  def change
  	change_column_null :events, :description, false
  	add_column :events, :features, :text
  	add_column :events, :invite_text, :text
  end
end
