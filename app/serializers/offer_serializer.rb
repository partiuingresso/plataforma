class OfferSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :quantity, :sold

  attribute :price do |object|
    {
      amount: object.price.to_f,
      display: object.price.format
    }
  end

  attribute :price_with_fee do |object|
    {
      amount: object.price_with_service_fee.to_f,
      display: object.price_with_service_fee.format
    }
  end

  attribute :available do |object|
  	object.available?
  end
end
