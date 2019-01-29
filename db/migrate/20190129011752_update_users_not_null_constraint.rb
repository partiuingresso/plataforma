class UpdateUsersNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :users, :first_name, false
  	change_column_null :users, :last_name, false
  	change_column_null :users, :age, false
  	change_column_null :users, :cpf, false
  	change_column_null :users, :role, false
  end

  def down
  	change_column_null :users, :first_name, true
  	change_column_null :users, :last_name, true
  	change_column_null :users, :age, true
  	change_column_null :users, :cpf, true
  	change_column_null :users, :role, true
  end

end
