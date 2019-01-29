class UpdateEventsTable < ActiveRecord::Migration[5.2]
  def change
  	rename_column :events, :start, :start_t
  	rename_column :events, :end, :end_t
  end
end
