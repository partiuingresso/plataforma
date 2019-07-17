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
					items: order.order_items.costly.collect do |order_item|
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
				remaining_time = ((@order.event.start_t - Time.current) / 1.minute).round
				delay_capture = remaining_time < (72.hours / 1.minute)
				@wirecard_payment = API.payment.create(order_moip_id,
					{
						installmentCount: payment.installment_count,
						statementDescriptor: "PartiuIngress",
						delayCapture: delay_capture,
						fundingInstrument: {
							method: "CREDIT_CARD",
							creditCard: {
								hash: payment.hash,
								store: false,
								holder: {
									# fullname: payment.holder_fullname,
									fullname: "CANCEL",
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
				if delay_capture
					CancelPendingOrderJob.set(wait: waiting_time(remaining_time)).perform_later(@order.id)
				end
			end

			def waiting_time(remaining_time)
				((1435.0 / (4320 ** 2)) * remaining_time ** 2 + 5).round.minutes
			end

			def validate_order_creation!
				unless @wirecard_order.respond_to?(:status) && @wirecard_order.status == "CREATED"
					Rails.logger.error @wirecard_order.inspect
					raise CheckoutErrors::OrderError
				end
			end

			def validate_payment_creation!
				unless @wirecard_payment.respond_to?(:status) && wirecard_payment.status != "CANCELLED"
					Rails.logger.error @wirecard_payment.inspect
					if @wirecard_payment.respond_to?(:cancellation_details)
						code = @wirecard_payment.cancellation_details.code
					else
						code = nil
					end

					raise CheckoutErrors::PaymentError.new(code)
				end
			end
	end
end