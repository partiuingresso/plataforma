class SellersChangeNull < ActiveRecord::Migration[5.2]
  def change
  	change_column_null :sellers, :name, true
  	change_column_null :sellers, :business_name, true
  	change_column_null :sellers, :document_number, true
  	change_column_null :sellers, :phone_area_code, true
  	change_column_null :sellers, :phone_number, true
  	change_column_null :sellers, :address_id, true
  end
end
