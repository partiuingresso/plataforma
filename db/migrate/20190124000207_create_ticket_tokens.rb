class CreateTicketTokens < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_tokens do |t|
      t.string :code
      t.string :owner_name
      t.string :owner_email
      t.references :ticket
      t.references :validation
      t.references :ticket_status

      t.timestamps
    end
  end
end
