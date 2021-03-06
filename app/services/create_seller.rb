class CreateSeller < ApplicationService
	attr_reader :user, :account_data, :company_data

	def initialize(user, account_data)
		@user = user
		@account_data = account_data
		@company_data = account_data[:company]
		format_data
	end

	def call
		begin
			ActiveRecord::Base.transaction do
				@seller = user.build_seller(
					email: account_data[:help_email],
					phone_area_code: account_data[:phone_area_code],
					phone_number: account_data[:phone_number]
				)
				@company = build_company unless company_data.nil?
				# Cria conta transparente
				account = Wirecard::create_account person, @company
				# Cancela operação se a conta transparente não for criada com sucesso
				raise ActiveRecord::Rollback unless account.respond_to?(:id)
				# Criar seller
				@seller.moip_id = account.id
				@seller.moip_access_token = account.access_token
				@seller.save!
				# Atualizar usuário
				@user.update!(cpf: account_data[:document_number], birthday: account_data[:birthdate], role: 3)
				# Criar empresa se for necessário
				@company.save! unless @company.nil?
				@success = true
			end
		rescue => e
			@success = false
			raise
		end

		return self
	end

	private

		def build_company
			company_data[:address_attributes] = company_data.delete :address
			company = @seller.build_company(
				company_data.slice(
					:name,
					:business_name,
					:document_number,
					:address_attributes
				)
			)
		end

		def person
			person_data = account_data.to_h.merge({
				email: @user.email,
				first_name: @user.first_name,
				last_name: @user.last_name
			})

			RecursiveOpenStruct.new(person_data)
		end

		def format_data
			@account_data = format_phone(@account_data)
			@account_data = format_birthdate(@account_data)
			@account_data = @account_data.symbolize_keys
		end

		def format_phone(data)
			phone = data[:phone]
			unless phone.nil?
				data.to_h.merge({
					phone_area_code: /\(\d\d\)/.match(phone).to_s.gsub(/[()]/, ''),
					phone_number: /(?:\d\s*)?[0-9]{4}-?[0-9]{4}/.match(phone).to_s.gsub(/\s+/, '').sub(/-/, '')
				})
			end
		end

		def format_birthdate(data)
			birthdate = data[:birthdate]
			unless birthdate.nil?
				data.to_h.merge({
					birthdate: Date.strptime(birthdate, "%d/%m/%Y").strftime("%Y-%m-%d")
				})
			end
		end
end