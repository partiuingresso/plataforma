class Order < ApplicationRecord
  enum status: { pending: "pending", approved: "approved", denied: "denied", refunded: "refunded" }
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :payment
  belongs_to :event
  has_one :company, through: :event
  has_many :offers, through: :order_items
  has_many :ticket_tokens, through: :order_items

  before_create :generate_order_number
  before_save :update_subtotal
  after_initialize :default_values

  accepts_nested_attributes_for :order_items

  monetize :subtotal_cents
  monetize :total_cents
  monetize :absolute_fee_cents

  def subtotal_cents
    order_items.collect { |order_item| order_item.quantity * order_item.offer.price_cents }.sum
  end

  def total_cents
    subtotal_cents * (1 + self.fee)
  end

  def absolute_fee_cents
    self.fee * subtotal_cents
  end

  def total_quantity
    order_items.collect { |order_item| order_item.quantity }.sum
  end

  def approved!
    super
    ticket_tokens.each do |ticket_token|
      if ticket_token.pending?
        ticket_token.ready!
      end
    end
  end

  def denied!
    ticket_tokens.each do |ticket_token|
      if ticket_token.pending?
        ticket_token.cancelled!
      end
    end
    order_items.each do |order_item|
      order_item.cancel
    end
    super
  end

  def refunded!
    ticket_tokens.each do |ticket_token|
        ticket_token.cancelled!
    end
    order_items.each do |order_item|
      order_item.cancel
    end
    super
  end

  private

    def default_values
      # *** Taxa de serviço ***
      self.fee ||= 0.1
      # ***********************
      self.status ||= :pending
    end

    def generate_order_number
      now = DateTime.now
      year = (now.year % 100).to_s
      month = now.month.to_s.rjust(2, "0")
      day = now.day.to_s.rjust(2, "0")

      order_number = year + month + day

      loop do
        order_number += rand(10 ** 6).to_s.rjust(7, "0")
        order_number = order_number.to_i
        break unless Order.exists?(number: order_number)
      end

      self.number = order_number
    end

    def update_subtotal
      self.subtotal_cents = subtotal_cents
    end

end
