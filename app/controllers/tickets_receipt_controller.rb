class TicketsReceiptController < ApplicationController
	def show
		confirmations = $confirmation_cache.read("confirmations")
		puts confirmations
		if confirmations.has_key?(params[:number].to_i)
			confirmations[params[:number].to_i] = true
		end
	end
end
