module Wirecard
	token = Rails.application.credentials.dig(:wirecard_sandbox_api_token)
	key = Rails.application.credentials.dig(:wirecard_sandbox_api_key)
	auth = Moip2::Auth::Basic.new(token, key)
	client = Moip2::Client.new(:sandbox, auth)

	@@api = Moip2::Api.new(client)

	def self.api
		@@api
	end

	def self.process_checkout? order_data, payment_data
		order = create_order order_data
		if order.status.present? && order.status == "CREATED"
			payment = create_payment order.id, payment_data
			if payment.status.present? && payment.status == "CREATED"
				return true
			end
		end

		return false
	end

	def self.create_order order
		order = api.order.create({
			own_id: order.number,
			amount: {
				currency: "BRL",
				subtotals: { addition: (order.fee * order.subtotal) * 100 }
			},
			items: order.order_items.collect do |order_item|
				{
					product: order_item.offer.name,
					quantity: order_item.quantity,
					price: order_item.offer.price * 100
				}
			end,
			customer: {
				ownId: order.user.id,
				fullname: order.user.name.full,
				email: order.user.email
			}
		})
	end

	def self.create_payment order_id, payment
		payment = api.payment.create(order_id,
			{
				installmentCount: 1,
				fundingInstrument: {
					method: "CREDIT_CARD",
					creditCard: {
						hash: payment.hash,
						store: false,
						holder: {
							fullname: payment.holder_fullname,
							birthdate: payment.holder_birthdate,
							taxDocument: {
								type: "CPF",
								number: payment.holder_cpf
							},
							phone: {
								countryCode: "55",
								areaCode: "21",
								number: payment.holder_phone
							},
							billingAddress: {
								street: payment.billing_address_street,
								streetNumber: payment.billing_address_number,
								complement: payment.billing_address_complement,
								district: payment.billing_address_district,
								city: payment.billing_address_city,
								state: payment.billing_address_state,
								country: "Brasil",
								zipCode: payment.billing_address_zipcode
							}
						}
					}
				}
			}
		)
	end
end
