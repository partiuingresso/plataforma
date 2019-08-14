class OfferSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :allotment, :quantity, :sold, :description, :start_t, :end_t

  attribute :start_t do |object|
    object.start_t.strftime("%Y-%m-%dT%H:%M")
  end

  attribute :end_t do |object|
    object.end_t.strftime("%Y-%m-%dT%H:%M")
  end

  attribute :price do |object|
      object.price.to_f
  end

  attribute :price_with_fee do |object|
      object.price_with_service_fee.to_f
  end

  attribute :available do |object|
  	object.available?
  end
end
