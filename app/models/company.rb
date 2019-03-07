class Company < ApplicationRecord
    has_many :events
    has_one :company_finance
    has_many :users
    has_one :bank_account, through: :company_finance

    validates :name, presence: true
	validates :moip_id, presence: true
	validates :moip_access_token, presence: true
end
