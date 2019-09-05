class Seller < ApplicationRecord
    has_many :events
    has_one :finance
    has_many :transfers, -> { order(created_at: :desc) }
    has_many :users
    has_one :bank_account, through: :finance
    belongs_to :address, optional: true # TODO: Remover essa relação
    has_many :orders, through: :events
    belongs_to :owner, class_name: :User
    has_one :company

	validates :moip_id, presence: true
	validates :moip_access_token, presence: true

    def name
        company&.name || owner.name.familiar
    end
end
