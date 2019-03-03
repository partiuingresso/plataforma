module OrdersHelper
	def installment_info(count)
		count.to_s + "x de " + ((@order.total * (1 + Wirecard::InterestTable[count])) / count).format
	end

	def price_with_interest(count)
		(@order.total * (1 + Wirecard::InterestTable[count])).format
	end
end
