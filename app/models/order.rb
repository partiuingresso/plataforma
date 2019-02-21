class Order < ApplicationRecord
  belongs_to :user
  belongs_to :order_status
  has_many :order_items
  has_one :payment
  has_many :events, through: :order_items
  has_many :offers, through: :order_items

  before_create :set_order_status
  before_save :update_subtotal

  accepts_nested_attributes_for :order_items

  def subtotal
    order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.offer.price) : 0 }.sum
  end

  def event
    if self.new_record?
      order_items.first.offer.event
    else
      events.first
    end
  end

private
  def set_order_status
    self.order_status_id = 1
  end

  def update_subtotal
    self[:subtotal] = subtotal
  end

end
