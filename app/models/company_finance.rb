class CompanyFinance < ApplicationRecord
  belongs_to :company

  validates :legal_name, presence: true
  validates :document_type, presence: true
  validates :document_number, presence: true
  validates :bank_code, presence: true
  validates :account_type, presence: true
  validates :agency_number, presence: true
  validates :account_number, presence: true
  validates :account_check_number, presence: true
  validates :moip_id, presence: true
  validates :access_token, presence: true

end
