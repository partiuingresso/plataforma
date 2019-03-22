module Wirecard

	autoload :Webhooks, 'webhooks'

	@@app_id = Rails.application.credentials.dig(:wirecard_app_id)
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
		{
			events: [
				"ORDER.PAID", "ORDER.NOT_PAID", "ORDER.REVERTED",
				"TRANSFER.COMPLETED", "TRANSFER.FAILED"
			],
			target: url,
			media: "WEBHOOK"
		},
		@@app_id
	)

	def self.notification_token
		@@notification.token
	end

	def self.process_checkout? order, payment_data
		response_order = create_order order, payment_data.installment_count
		if response_order.respond_to?(:status) && response_order.status.present?
			payment_response = create_payment response_order.id, payment_data
			if payment_response.respond_to?(:status) && payment_response.status.present?
				payment = OrderPayment.new
				payment.amount_cents = payment_response.amount.total
				payment.installment_count = payment_response.installment_count
				payment.interest_rate = Business::Finance::InterestRate[payment.installment_count]
				payment.card_brand = payment_response.funding_instrument.credit_card.brand
				payment.card_number_last_4 = payment_response.funding_instrument.credit_card.last4
				payment.order = order

				return payment
			end
		end

		return nil
	end

	def self.create_order order, installment_count
		absolute_interest_cents = (Business::Finance::InterestRate[installment_count] * order.total).cents
		addition = order.absolute_fee_cents + absolute_interest_cents
		order = api.order.create({
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
				fullname: order.user.name.full,
				email: order.user.email
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
	end

	def self.create_payment order_id, payment
		payment = api.payment.create(order_id,
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

	def self.create_account person, company
		account = api.accounts.create(
			{
				email: {
					address: person.email
				},
				person: {
					name: person.first_name,
					lastName: person.last_name,
					taxDocument: {
						type: "CPF",
						number: person.document_number.gsub(/[.\-]/, "")
					},
					birthDate: person.birthdate.strftime("%Y-%m-%d"),
					phone: {
						countryCode: "55",
						areaCode: person.phone_area_code.to_s,
						number: person.phone_number.to_s
					},
					address: {
						street: person.address.address,
						streetNumber: person.address.number,
						complement: person.address.complement,
						district: person.address.district,
						zipCode: person.address.zipcode.gsub(/[.\-]/, ""),
						city: person.address.city,
						state: person.address.state,
						country: "BRA"
					}
				},
				company: {
					name: company.name,
					businessName: company.business_name,
					taxDocument: {
						type: "CNPJ",
						number: company.document_number.gsub(/[.\-\/]/, "")
					},
					phone: {
						countryCode: "55",
						areaCode: company.phone_area_code,
						number: company.phone_number
					},
					address: {
						street: company.address.address,
						streetNumber: company.address.number,
						complement: company.address.complement,
						district: company.address.district,
						zipCode: company.address.zipcode.gsub(/[.\-]/, ""),
						city: company.address.city,
						state: company.address.state,
						country: "BRA"
					}
				},
				type: "MERCHANT",
				transparentAccount: true
			}
		)
	end

	def self.create_bank_account company
		moip_id = company.moip_id
		bank_account = company.company_finance.bank_account
		new_bank_account = api(company.moip_access_token).bank_accounts.create(moip_id,
			{
				type: bank_account.account_type,
				bankNumber: bank_account.bank_code,
				agencyNumber: bank_account.agency_number.to_i,
				agencyCheckNumber: bank_account.agency_check_number,
				accountNumber: bank_account.account_number.to_i,
				accountCheckNumber: bank_account.account_check_number.to_i,
				holder: {
					fullname: bank_account.legal_name,
					taxDocument: {
						type: bank_account.document_type,
						number: bank_account.document_number.gsub(/[.\/-]/, '')
					}
				}
			}
		)
	end

	def self.delete_bank_account company
		api(company.moip_access_token).bank_accounts.delete(company.bank_account.moip_id)
	end

	def self.bank_accounts company
		bank_accounts = api(company.moip_access_token).bank_accounts.find_all(company.moip_id).parsed_response
		bank_accounts.map do |bank_account_hash|
			RecursiveOpenStruct.new bank_account_hash
		end
	end

	def self.update_bank_account company
		bank_account = company.company_finance.bank_account
		new_bank_account = api(company.moip_access_token).bank_accounts.update(bank_account.moip_id,
			{
				type: bank_account.account_type,
				bankNumber: bank_account.bank_code,
				agencyNumber: bank_account.agency_number.to_i,
				agencyCheckNumber: bank_account.agency_check_number,
				accountNumber: bank_account.account_number.to_i,
				accountCheckNumber: bank_account.account_check_number.to_i,
				holder: {
					fullname: bank_account.legal_name,
					taxDocument: {
						type: bank_account.document_type,
						number: bank_account.document_number.gsub(/[.\/-]/, '')
					}
				}
			}
		)
		new_bank_account.respond_to?(:id) && new_bank_account.id.present?
	end

	def self.show_balances company
		api(company.moip_access_token).balances.show()
	end

	def self.create_transfer transfer
		company = transfer.company
		transfer = api(company.moip_access_token).transfer.create(
			{
				ownId: transfer.id,
				amount: transfer.amount_cents,
				transferInstrument: {
					method: "BANK_ACCOUNT",
					bankAccount: {
						id: transfer.bank_account.moip_id
					}
				}
			}
		)
	end

	def self.transfer_to company, amount
		transfer = api.transfer.create(
			{
				amount: amount,
				transferInstrument: {
					method: "MOIP_ACCOUNT",
					moipAccount: {
						id: company.moip_id
					}
				}
			}
		)
	end
end
