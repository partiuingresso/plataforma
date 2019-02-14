class User < ApplicationRecord
  has_many :credit_cards
  has_many :orders
  belongs_to :company, optional: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable

  has_person_name

  validates :first_name, presence: true
  validates :last_name, presence: true

  enum role: [:user, :producer, :producer_admin, :admin]
  after_initialize :set_default_role, :if => :new_record?


  def timeout_in
   return 1.minute if admin?
   1.days
  end

  def set_default_role
    self.role ||= :user
  end
end
