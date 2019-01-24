class OrderItem < ApplicationRecord
  belongs_to :offer
  belongs_to :order
  has_many :tickets

  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :offer_present
  validate :order_present

  before_save :finalize

  def unit_price
    if persisted?
      self[:unit_price]
    else
      offer.unit_price
    end
  end

  def total_price
    unit_price * quantity
  end

private

  def offer_present
    if offer.nil?
      errors.add(:offer, "não é válido ou ativo.")
    end
  end

  def order_present
    if order.nil?
      errors.add(:order, "não é um pedido válido.")
    end
  end

  def finalize
    self[:unit_price] = unit_price
    self[:total_price] = quantity * self[:unit_price]
  end

end
