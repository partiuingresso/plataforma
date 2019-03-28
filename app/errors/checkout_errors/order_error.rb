module CheckoutErrors
	class OrderError < StandardError
		def initialize(msg="Não foi possível realizar o pedido. Tente novamente.")
			super(msg)
		end
	end
end