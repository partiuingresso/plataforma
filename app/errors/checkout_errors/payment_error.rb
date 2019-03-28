module CheckoutErrors
	class PaymentError < StandardError
		def initialize(code=nil)
			msg = case code.to_i
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

			super(msg)
		end
	end
end