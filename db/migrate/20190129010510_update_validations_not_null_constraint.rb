class UpdateValidationsNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :validations, :time, false
  	change_column_null :validations, :user_id, false
  end

  def down
  	change_column_null :validations, :time, true
  	change_column_null :validations, :user_id, true
  end

end
