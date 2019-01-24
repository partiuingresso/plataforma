class CreateCompanyFinances < ActiveRecord::Migration[5.2]
  def change
    create_table :company_finances do |t|
      t.string :bank_code
      t.string :agencia
      t.string :agencia_dv
      t.string :conta
      t.string :type
      t.string :conta_dv
      t.string :document_number
      t.string :legal_name
      t.timestamps
    end
  end
end
