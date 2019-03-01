class CompanyFinance < ApplicationRecord
  belongs_to :company

  attribute :business_name, :string

  attribute :phone, :string
  attribute :birth_date, :datetime

  attribute :address, :string
  attribute :number, :string
  attribute :complement, :string
  attribute :district, :string
  attribute :city, :string
  attribute :state, :string
  attribute :zipcode, :string

  validates :legal_name, presence: true
  validates :phone, presence: true, on: :create
  validates :birth_date, presence: true, on: :create
  validates :document_type, presence: true
  validates :document_number, presence: true
  validates :bank_code, presence: true, numericality: { only_integer: true }
  validates :account_type, presence: true
  validates :agencia, presence: true, numericality: { only_integer: true }
  validates :agencia_dv, numericality: { only_integer: true }, allow_blank: true
  validates :conta, presence: true, numericality: { only_integer: true }
  validates :conta_dv, presence: true, numericality: { only_integer: true }
  validates :moip_id, presence: true

  validates :address, presence: true, on: :create
  validates :number, presence: true, on: :create
  validates :district, presence: true, on: :create
  validates :city, presence: true, on: :create
  validates :state, presence: true, on: :create
  validates :zipcode, presence: true, on: :create
end
