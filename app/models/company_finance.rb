class CompanyFinance < ApplicationRecord
  belongs_to :company
  belongs_to :bank_account

  accepts_nested_attributes_for :bank_account

  validates_associated :bank_account
end
