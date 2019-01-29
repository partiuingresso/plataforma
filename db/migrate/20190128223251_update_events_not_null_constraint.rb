class UpdateEventsNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :events, :name, false
  	change_column_null :events, :start, false
  	change_column_null :events, :user_id, false
  end

  def down
  	change_column_null :events, :name, true
  	change_column_null :events, :start, true
  	change_column_null :events, :user_id, true
  end

end
