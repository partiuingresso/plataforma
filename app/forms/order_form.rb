class OrderForm
	include ActiveModel::Model

	attr_accessor(
		:success, # Indicates whether the save was successfull
		:order, # Order instance
		:user,
		:event_id,
		:order_items, # List of Order Item Form
		:payment # The order payment form
	)

	validates :user, presence: true
	validates :event_id, presence: true
	validate :payment_valid
	validate :order_items_valid

	def initialize(attributes={})
		super
		@order_items ||= []
		@payment ||= PaymentForm.new
	end

	def save
		begin
			if valid?
				@order = Order.new({
					event_id: event_id,
					user: user,
					order_items_attributes: build_order_items_attributes
				})
				@order.save!
				p = Wirecard::process_checkout? @order, payment
				p.save!
			else
				@success = false
			end
		rescue => e
			self.errors.add(:base, e.message)
			@success = false
		end		
	end

	def order_items_attributes=(order_items_params)
		@order_items ||= []
		order_items_params.each do |i, order_item_params|
			if order_item_params[:quantity].to_i > 0
				@order_items.push(OrderItemForm.new(order_item_params))
			end
		end
	end

	def payment_attributes=(payment_params)
		@payment = PaymentForm.new(payment_params)
	end

	private

		def build_order_items_attributes
			order_items.map do |order_item|
				order_item.serializable_hash
			end
		end

		def payment_valid
			if payment.nil?
				self.errors.add(:base, "Payment can't be blank.")
			elsif payment.invalid?
				payment.errors.full_messages.each do |full_message|
					self.errors.add(:base, full_message)
				end
			end
		end

		def order_items_valid
			if order_items.empty?
				self.errors.add(:base, "Order items can't be empty.")
			else
				order_items.each do |order_item|
					next if order_item.valid?
					order_item.errors.full_messages.each do |full_message|
						self.errors.add(:base, full_message)
					end
				end
			end
		end
end