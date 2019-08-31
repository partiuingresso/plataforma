class Seller < ApplicationRecord
    has_many :events
    has_one :finance
    has_many :transfers, -> { order(created_at: :desc) }
    has_many :users
    has_one :bank_account, through: :finance
    belongs_to :address
    has_many :orders, through: :events

	validates :name, presence: true
	validates :moip_id, presence: true
	validates :moip_access_token, presence: true

    accepts_nested_attributes_for :address
end
