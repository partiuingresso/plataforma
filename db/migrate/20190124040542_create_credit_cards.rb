class CreateCreditCards < ActiveRecord::Migration[5.2]
  def change
    create_table :credit_cards do |t|
      t.string :cardid
      t.timestamps
    end
  end
end
