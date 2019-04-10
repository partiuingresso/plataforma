class User < ApplicationRecord
  include PgSearch
  has_many :credit_cards
  has_many :orders
  has_many :ticket_tokens, through: :orders
  belongs_to :company, optional: true

  pg_search_scope :search_user, against: [:first_name, :last_name, :email],
                    using: {
                    tsearch: {any_word: true, prefix: true}
                  }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :trackable

  has_person_name

  validates :first_name, presence: true
  validates :last_name, presence: true

  enum role: [:guest, :user, :producer, :producer_admin, :admin]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :user
  end

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # Timeout for dev
  def timeout_in
    unless Rails.env.production?
      return 1.year if admin?
      1.days
    end
  end

  def has_no_password?
    self.encrypted_password.blank?
  end

  protected

    def password_required?
      confirmed? ? super : false
    end

end
