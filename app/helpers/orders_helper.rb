module OrdersHelper
	def installment_info(count)
		count.to_s + "x de R$" + price_with_interest(count)
	end

	def price_with_interest(count)
		value_to_currency(@order.total * (1 + Wirecard::InterestTable[count]))
	end
end
