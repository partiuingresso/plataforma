class UpdateCreditCardsNotNullConstraint < ActiveRecord::Migration[5.2]

  def up
  	change_column_null :credit_cards, :cardid, false
  	change_column_null :credit_cards, :user_id, false
  end

  def down
  	change_column_null :credit_cards, :cardid, true
  	change_column_null :credit_cards, :user_id, true
  end

end
