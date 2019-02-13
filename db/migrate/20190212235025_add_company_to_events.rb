class AddCompanyToEvents < ActiveRecord::Migration[5.2]
  def change
  	add_reference :events, :company, foreign_key: true, null: false
  end
end
