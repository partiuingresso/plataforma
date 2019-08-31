module Wirecard
	API_ENV = Rails.env.production? ? :production : :sandbox

	access_token = Rails.application.credentials.dig(:wirecard, API_ENV, :access_token)
	auth = Moip2::Auth::OAuth.new(access_token)
	client = Moip2::Client.new(API_ENV, auth)

	API = Moip2::Api.new(client)

	def self.api(token = nil)
		if token.nil?
			API
		else
			auth = Moip2::Auth::OAuth.new(token)
			client = Moip2::Client.new(API_ENV, auth)
			Moip2::Api.new(client)
		end
	end

	if Rails.env.development?
		if Ngrok::Tunnel.stopped?
			Ngrok::Tunnel.start({ port: 300 })
		end
		url = Ngrok::Tunnel.ngrok_url_https + "/webhooks"

		app_id = Rails.application.credentials.dig(:wirecard, API_ENV, :app_id)
		@@notification = api.notifications.create(
			{
				events: [
					"ORDER.PAID", "ORDER.NOT_PAID", "ORDER.REVERTED",
					"PAYMENT.PRE_AUTHORIZED",
					"TRANSFER.COMPLETED", "TRANSFER.FAILED"
				],
				target: url,
				media: "WEBHOOK"
			},
			app_id
		)
	else
		notification_id = Rails.application.credentials.dig(:wirecard, API_ENV, :notification_id)
		@@notification = api.notifications.show(notification_id)
	end

	def self.notification_token
		@@notification.token
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

	def self.create_bank_account seller
		moip_id = seller.moip_id
		bank_account = seller.finance.bank_account
		new_bank_account = api(seller.moip_access_token).bank_accounts.create(moip_id,
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

	def self.delete_bank_account seller
		api(seller.moip_access_token).bank_accounts.delete(seller.bank_account.moip_id)
	end

	def self.bank_accounts seller
		bank_accounts = api(seller.moip_access_token).bank_accounts.find_all(seller.moip_id).parsed_response
		bank_accounts.map do |bank_account_hash|
			RecursiveOpenStruct.new bank_account_hash
		end
	end

	def self.update_bank_account seller
		bank_account = seller.finance.bank_account
		new_bank_account = api(seller.moip_access_token).bank_accounts.update(bank_account.moip_id,
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

	def self.show_balances seller
		api(seller.moip_access_token).balances.show()
	end

	def self.create_transfer transfer
		seller = transfer.seller
		bank_account = seller.finance.bank_account
		transfer = api(seller.moip_access_token).transfer.create(
			{
				ownId: transfer.id,
				amount: transfer.amount_cents,
				transferInstrument: {
					method: "BANK_ACCOUNT",
					bankAccount: {
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
				}
			}
		)
	end

	def self.transfer_to seller, amount
		transfer = api.transfer.create(
			{
				amount: amount,
				transferInstrument: {
					method: "MOIP_ACCOUNT",
					moipAccount: {
						id: seller.moip_id
					}
				}
			}
		)
	end

	def self.show_order order_moip_id
		api.order.show(order_moip_id)
	end
end
