class Company < ApplicationRecord
    has_many :events
    has_one :company_finance
    has_many :transfers, -> { order(created_at: :desc) }
    has_many :users
    has_one :bank_account, through: :company_finance
    belongs_to :address

    attribute :phone, :string
    @phone_regex = /\A\(\d\d\)\s*(?:\d\s*)?[0-9]{4}-?[0-9]{4}\z/
    class << self
        attr_reader :phone_regex
    end

    validates :name, presence: true
    validates :business_name, presence: true
    validates :document_type, presence: true
    validates :document_number, presence: true
    validates :phone, presence: true, format: self.phone_regex
    validates :phone_area_code, presence: true
    validates :phone_number, presence: true
	validates :moip_id, presence: true
	validates :moip_access_token, presence: true
    validates_associated :address

    accepts_nested_attributes_for :address

    def phone=(value)
        super
        if Company.phone_regex.match?(value)
            self.phone_area_code = /\(\d\d\)/.match(value).to_s.gsub(/[()]/, '')
            self.phone_number = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(value).to_s.gsub(/\s+/, '').sub(/-/, '')
        end
    end
end
