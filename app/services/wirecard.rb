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
	access_token = Rails.application.credentials.dig(:wirecard_sandbox_api_access_token)
	auth = Moip2::Auth::OAuth.new(access_token)
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
		current_notifications = api.notifications.find_all
		current_notifications.each do |notification|
			api.notifications.delete notification["id"]
		end
	else
		url = "https://moip.partiuingresso.com/webhooks"
	end

	@@notification = api.notifications.create(
		events: ["ORDER.PAID", "ORDER.NOT_PAID", "ORDER.REVERTED"],
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

	def self.create_account user, company_finance
		phone_area_code = /(\d\d)/.match(company_finance.phone).to_s
		phone_number = /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(company_finance.phone).to_s.gsub(/\s+/, '').sub(/-/, '')
		account = api.accounts.create(
			{
				transparentAccount: true,
				email: {
					address: user.email
				},
				person: {
					name: user.first_name,
					lastName: user.last_name,
					taxDocument: {
						type: company_finance.document_type,
						number: company_finance.document_number
					},
					birthDate: company_finance.birth_date.strftime("%Y-%m-%d"),
					phone: {
						countryCode: "55",
						areaCode: phone_area_code,
						number: phone_number
					},
					address: {
						street: company_finance.address,
						streetNumber: company_finance.number,
						complement: company_finance.complement,
						district: company_finance.district,
						zipCode: company_finance.zipcode,
						city: company_finance.city,
						state: company_finance.state,
						country: "BRA"
					}
				},
				company: {
					name: "Partiu Ingresso",
					businessName: "CR COMUNICAÇÃO E TECNOLOGIA LTDA",
					taxDocument: {
						type: "CNPJ",
						number: "31.419.883/0001-00"
					},
					phone: {
						countryCode: "55",
						areaCode: "21",
						number: "997754668"
					},
					address: {
						street: "Av. Belisário Leite de Andrade Neto",
						streetNumber: "354",
						complement: "101",
						district: "Barra da Tijuca",
						zipCode: "22621270",
						city: "Rio de Janeiro",
						state: "RJ",
						country: "BRA"
					}
				},
				type: "MERCHANT"
			}
		)
	end
end
