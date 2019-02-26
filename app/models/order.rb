class Order < ApplicationRecord
  enum status: { pending: "pending", approved: "approved", denied: "denied", refunded: "refunded" }
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_one :payment
  has_many :events, through: :order_items
  has_many :offers, through: :order_items
  has_many :ticket_tokens, through: :order_items

  before_create :generate_order_number
  before_save :update_subtotal
  after_initialize :default_values

  accepts_nested_attributes_for :order_items

  def subtotal
    order_items.collect { |oi| oi.quantity * oi.offer.price }.sum
  end

  def event
    if self.new_record?
      order_items.first.offer.event
    else
      events.first
    end
  end

  def total_quantity
    order_items.collect { |oi| oi.quantity }.sum
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
    super
    ticket_tokens.each do |ticket_token|
      if ticket_token.pending?
        ticket_token.cancelled!
      end
    end
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
      self[:subtotal] = subtotal
    end

end
