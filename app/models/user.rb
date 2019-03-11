class User < ApplicationRecord
  has_many :credit_cards
  has_many :orders
  has_many :ticket_tokens, through: :orders
  belongs_to :company, optional: true
  belongs_to :address, optional: true

  accepts_nested_attributes_for :address

  attribute :phone, :string
  @phone_regex = /\A\(\d\d\)\s*(?:\d\s*)?[0-9]{4}-?[0-9]{4}\z/
  class << self
      attr_reader :phone_regex
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable

  has_person_name

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone, format: self.phone_regex, allow_blank: true
  validates_associated :address

  enum role: [:guest, :user, :producer, :producer_admin, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def phone=(value)
      super
      if Company.phone_regex.match?(value)
          self.phone_area_code = /\(\d\d\)/.match(value).to_s.gsub(/[()]/, '')
          self.phone_number = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(value).to_s.gsub(/\s+/, '').sub(/-/, '')
      end
  end

  def set_default_role
    self.role ||= :user
  end

  def latest_order
    orders.order(:created_at).last
  end

  # Timeout for dev
  def timeout_in
   return 1.year if admin?
   1.days
  end

end
