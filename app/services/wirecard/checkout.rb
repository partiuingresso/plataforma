module Wirecard
	class Checkout
		include Wirecard
		
		attr_accessor :order, :payment, :order_moip_id, :wirecard_order, :wirecard_payment, :error

		def initialize(order, payment)
			@order = order
			@payment = payment
			@error = nil
		end

		def process?
			create_order
			unless wirecard_order_valid?
				return false
			end

			@order_moip_id = wirecard_order.id
			create_payment

			wirecard_payment_valid?
		end

		private

			def create_order
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

			def create_payment
				begin
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
										},
										billingAddress: {
											street: payment.billing_address.address,
											streetNumber: payment.billing_address.number,
											complement: payment.billing_address.complement,
											district: payment.billing_address.district,
											city: payment.billing_address.city,
											state: payment.billing_address.state,
											country: "Brasil",
											zipCode: payment.billing_address.zipcode
										}
									}
								}
							}
						}
					)
				rescue NotFoundError => error
					self.error = error.message
				end
			end

			def wirecard_order_valid?
				unless @wirecard_order.respond_to?(:status) && @wirecard_order.status == "CREATED"
					self.error = "Erro ao criar pedido."

					return false
				end

				return true
			end

			def wirecard_payment_valid?
				unless @wirecard_payment.respond_to?(:status) && wirecard_payment.status != "CANCELLED"
					self.error = payment_error_message

					return false
				end

				return true
			end

			def payment_error_message
				case @wirecard_payment.cancellation_details.code
				when 1
					"Dados informados inválidos. Você digitou algo errado durante o preenchimento dos dados do seu "\
					"Cartão. Certifique-se de que está usando o Cartão correto e faça uma nova tentativa."	
				when 2
					"Houve uma falha de comunicação com o Banco Emissor do seu Cartão, tente novamente."
				when 3
					"O pagamento não foi autorizado pelo Banco Emissor do seu Cartão. Entre em contato com o Banco "\
					"para entender o motivo e refazer o pagamento."
				when 4
					"A validade do seu Cartão expirou."
				when 5
					"O pagamento não foi autorizado. Entre em contato com o Banco Emissor do seu Cartão."
				when 6
					"Esse pagamento já foi realizado. Caso não encontre nenhuma referência ao pagamento anterior, por "\
					"favor entre em contato com o nosso Atendimento."
				when 11
					"Houve uma falha de comunicação com o Banco Emissor do seu Cartão, tente novamente."
				when 12
					"Pagamento não autorizado para este Cartão. Entre em contato com o Banco Emissor para mais esclarecimentos."
				else
					"Não foi possível fazer o pagamento. Por favor, tente novamente."
				end
			end
	end
end