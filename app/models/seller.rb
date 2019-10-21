class Seller < ApplicationRecord
    has_one :user, as: :actor
    has_many :staff, class_name: :SellerStaff
    has_many :events
    has_one :finance
    has_many :transfers, -> { order(created_at: :desc) }
    has_one :bank_account, through: :finance
    belongs_to :address, optional: true # TODO: Remover essa relação
    has_many :orders, through: :events
    has_one :company

	validates :moip_id, presence: true
	validates :moip_access_token, presence: true

    def name
        company&.name || user.name.familiar
    end

    def staff_users
        staff.map { |s| s.user }
    end
end
