module Wirecard

	autoload :Webhooks, 'webhooks'

	InterestTable = { 1 => 0,
					  2 => 0.045,
					  3 => 0.0575,
					  4 => 0.07,
					  5 => 0.0825,
					  6 => 0.095,
					  7 => 0.10203,
					  8 => 0.11526,
					  9 => 0.12864,
					  10 => 0.145,
					  11 => 0.15549,
					  12 => 0.18 }

	token = Rails.application.credentials.dig(:wirecard_sandbox_api_token)
	key = Rails.application.credentials.dig(:wirecard_sandbox_api_key)
	auth = Moip2::Auth::Basic.new(token, key)
	client = Moip2::Client.new(:sandbox, auth)

	@@api = Moip2::Api.new(client)

	def self.api
		@@api
	end

	if Rails.env.development?
		if Ngrok::Tunnel.stopped?
			Ngrok::Tunnel.start({ port: 300 })
		end
		url = Ngrok::Tunnel.ngrok_url_https + "/webhooks"
	else
		url = "https://moip.partiuingresso.com/webhooks"
	end

	current_notifications = api.notifications.find_all
	current_notifications.each do |notification|
		api.notifications.delete notification.id
	end
	@@notification = api.notifications.create(
		events: ["ORDER.PAID", "ORDER.REVERTED"],
		target: url,
		media: "WEBHOOK"
	)

	def self.notification_token
		@@notification.token
	end

	def self.process_checkout? order_data, payment_data
		order = create_order order_data, payment_data.installment_count
		if order.respond_to?(:status) && order.status.present?
			payment = create_payment order.id, payment_data
			if payment.respond_to?(:status) && payment.status.present?
				return true
			end
			puts payment
		end

		return false
	end

	def self.create_order order, installment_count
		absolute_interest = Wirecard::InterestTable[installment_count] * order.total
		order = api.order.create({
			own_id: order.number,
			amount: {
				currency: "BRL",
				subtotals: { addition: (order.absolute_fee + absolute_interest) * 100 }
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
				installmentCount: payment.installment_count,
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
								areaCode: payment.holder_phone_area_code,
								number: payment.holder_phone_number
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
