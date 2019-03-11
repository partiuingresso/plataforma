class CompaniesRemoveDocumentType < ActiveRecord::Migration[5.2]
  def change
  	remove_column :companies, :document_type, :string, null: false
  end
end
