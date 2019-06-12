class OffersSetEndTNotNullable < ActiveRecord::Migration[5.2]
  def change
  	change_column_null :offers, :end_t, false
  end
end
