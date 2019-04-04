module Wirecard
	class Checkout
		include Wirecard
		
		attr_accessor :order, :payment, :order_moip_id, :wirecard_order, :wirecard_payment

		def initialize(order, payment)
			@order = order
			@payment = payment
		end

		def process!
			create_order!
			@order_moip_id = wirecard_order.id
			create_payment!
		end

		private

			def create_order!
				absolute_interest_cents = (Business::Finance::InterestRate[payment.installment_count] * order.total).cents
				addition = order.absolute_fee_cents + absolute_interest_cents
				@wirecard_order = API.order.create({
					own_id: order.number,
					amount: {
						currency: "BRL",
						subtotals: { addition: addition }
					},
					items: order.order_items.collect do |order_item|
						{
							product: order_item.offer.name,
							quantity: order_item.quantity,
							price: order_item.offer.price_cents
						}
					end,
					customer: {
						ownId: order.user.id,
						fullname: payment.holder_fullname,
						email: order.user.email,
						birthDate: payment.holder_birthdate.strftime("%Y-%m-%d"),
						taxDocument: {
							type: "CPF",
							number: payment.holder_document
						},
						phone: {
							countryCode: "55",
							areaCode: payment.holder_phone_area_code,
							number: payment.holder_phone_number
						},
						shippingAddress: {
							street: payment.billing_address.address,
							streetNumber: payment.billing_address.number,
							complement: payment.billing_address.complement,
							district: payment.billing_address.district,
							city: payment.billing_address.city,
							state: payment.billing_address.state,
							country: "Brasil",
							zipCode: payment.billing_address.zipcode
						}
					},
					receivers: [
						{
							type: "SECONDARY",
							feePayor: false,
							moipAccount: {
								id: order.company.moip_id
							},
							amount: {
								fixed: order.subtotal_cents
							}
						}
					]
				})
				validate_order_creation!
			end

			def create_payment!
				@wirecard_payment = API.payment.create(order_moip_id,
					{
						installmentCount: payment.installment_count,
						statementDescriptor: "PartiuIngress",
						fundingInstrument: {
							method: "CREDIT_CARD",
							creditCard: {
								hash: payment.hash,
								store: false,
								holder: {
									fullname: payment.holder_fullname,
									birthdate: payment.holder_birthdate.strftime("%Y-%m-%d"),
									taxDocument: {
										type: "CPF",
										number: payment.holder_document
									},
									phone: {
										countryCode: "55",
										areaCode: payment.holder_phone_area_code,
										number: payment.holder_phone_number
									}
								}
							}
						}
					}
				)
				validate_payment_creation!
			end

			def validate_order_creation!
				Rails.logger.debug @wirecard_order.inspect
				unless @wirecard_order.respond_to?(:status) && @wirecard_order.status == "CREATED"
					raise CheckoutErrors::OrderError
				end
			end

			def validate_payment_creation!
				Rails.logger.debug @wirecard_payment.inspect
				unless @wirecard_payment.respond_to?(:status) && wirecard_payment.status != "CANCELLED"
					raise CheckoutErrors::PaymentError.new(@wirecard_payment.cancellation_details.code)
				end
			end
	end
end