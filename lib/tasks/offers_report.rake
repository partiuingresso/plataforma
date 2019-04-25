desc "Generates a offer report CSV."
task :offers_report => :environment do |task|
	CSV.open("relatorio_de_ofertas.csv", "wb") do |csv|
		csv << ["Evento", "Oferta", "Quantidade", "Quantidade vendidos", "Quantidade disponíveis"]
		Offer.all.each do |offer|
			event = offer.event
			complete_name = "#{event.name} - #{event.address.city}/#{event.address.state}"
			csv << [complete_name, offer.name, offer.quantity.to_s, (offer.quantity - offer.available_quantity).to_s, offer.available_quantity.to_s]
		end
	end
end