module EventsHelper
	require 'uri'

	def google_maps_url(address)
		displacement = 0.0005
		coordinates = [(address.latitude + displacement), address.longitude].join(", ")
		url = URI.parse("https://www.google.com/maps/embed/v1/place")
		url.query = URI.encode_www_form(
			"key" => Rails.application.credentials.google_maps_api_key,
			"q" => address.full_address_without_name,
			"center" => coordinates
		)

		url.to_s
	end
end
