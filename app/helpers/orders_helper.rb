module OrdersHelper
	def installment_info(count)
		count.to_s + "x de " + ((@order.total * (1 + Business::Finance::InterestRate[count])) / count).format
	end

	def price_with_interest(count)
		(@order.total * (1 + Business::Finance::InterestRate[count])).format
	end
end
