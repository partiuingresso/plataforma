class TicketsReceiptController < ApplicationController
	def show
		confirmations = $confirmation_cache.read("confirmations")
		if confirmations.has_key?(params[:number].to_i)
			confirmations[params[:number].to_i] = true
			$confirmation_cache.write("confirmations", confirmations)
		end
	end
end
