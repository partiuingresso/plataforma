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

	def self.api(token = nil)
		if token.nil?
			@@api
		else
			auth = Moip2::Auth::OAuth.new(token)
			client = Moip2::Client.new(:sandbox, auth)
			Moip2::Api.new(client)
		end
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
			},
			receivers: [
				{
					type: "SECONDARY",
					feePayor: false,
					moipAccount: {
						id: order.company.company_finance.moip_id
					},
					amount: {
						fixed: order.subtotal * 100
					}
				}
			]
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

	def self.create_account
		account = api.accounts.create(
			{
				email: {
					address: "financeiro@partiuingresso.com"
				},
				person: {
					name: "Rodrigo",
					lastName: "Cortezi",
					taxDocument: {
						type: "CPF",
						number: "06035033733"
					},
					birthDate: "1996-12-18",
					phone: {
						countryCode: "55",
						areaCode: "21",
						number: "998025243"
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
				company: {
					name: "Partiu Ingresso",
					businessName: "CR COMUNICAÇÃO E TECNOLOGIA LTDA",
					taxDocument: {
						type: "CNPJ",
						number: "31419883000100"
					},
					phone: {
						countryCode: "55",
						areaCode: "21",
						number: "997754968"
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
				type: "MERCHANT",
				transparentAccount: true
			}
		)
	end

	def self.create_bank_account company_finance
		bank_account = api(company_finance.access_token).bank_accounts.create(company_finance.moip_id,
			{
				type: company_finance.account_type,
				bankNumber: company_finance.bank_code,
				agencyNumber: company_finance.agency_number.to_i,
				agencyCheckNumber: company_finance.agency_check_number,
				accountNumber: company_finance.account_number.to_i,
				accountCheckNumber: company_finance.account_check_number.to_i,
				holder: {
					fullname: company_finance.legal_name,
					taxDocument: {
						type: company_finance.document_type,
						number: company_finance.document_number.gsub(/[.\/-]/, '')
					}
				}
			}
		)
	end

	def self.bank_accounts company_finance
		bank_accounts = api(company_finance.access_token).bank_accounts.find_all(company_finance.moip_id).parsed_response
		bank_accounts.map do |bank_account_hash|
			RecursiveOpenStruct.new bank_account_hash
		end
	end

	def self.update_bank_account company_finance, bank_account_id
		bank_account = api(company_finance.access_token).bank_accounts.update(bank_account_id,
			{
				type: company_finance.account_type,
				bankNumber: company_finance.bank_code,
				agencyNumber: company_finance.agency_number.to_i,
				agencyCheckNumber: company_finance.agency_check_number,
				accountNumber: company_finance.account_number.to_i,
				accountCheckNumber: company_finance.account_check_number.to_i,
				holder: {
					fullname: company_finance.legal_name,
					taxDocument: {
						type: company_finance.document_type,
						number: company_finance.document_number.gsub(/[.\/-]/, '')
					}
				}
			}
		)
		bank_account.respond_to?(:id) && bank_account.id.present?
	end

	def self.show_balances company_finance
		api(company_finance.access_token).balances.show()
	end
end
