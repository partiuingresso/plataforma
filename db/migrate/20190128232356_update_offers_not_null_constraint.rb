class UpdateOffersNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :offers, :name, false
  	change_column_null :offers, :price, false
  	change_column_null :offers, :event_id, false
  end

  def down
  	change_column_null :offers, :name, true
  	change_column_null :offers, :price, true
  	change_column_null :offers, :event_id, true
  end

end
