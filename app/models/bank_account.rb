class BankAccount < ApplicationRecord
	has_one :finance
	has_many :transfers
	has_one :seller, through: :finance

  validates :legal_name, presence: true
  validates :document_type, presence: true
  validates :document_number, presence: true
  validates :bank_code, presence: true
  validates :account_type, presence: true
  validates :agency_number, presence: true
  validates :account_number, presence: true
end
