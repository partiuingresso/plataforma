class Company < ApplicationRecord
    has_many :events
    has_one :company_finance
    has_many :transfers, -> { order(created_at: :desc) }
    has_many :users
    has_one :bank_account, through: :company_finance
    belongs_to :address
    has_many :orders, through: :events

	validates :name, presence: true
	validates :moip_id, presence: true
	validates :moip_access_token, presence: true

    accepts_nested_attributes_for :address
end
