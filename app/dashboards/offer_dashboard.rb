require "administrate/base_dashboard"

class OfferDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    event: Field::BelongsTo,
    order_items: Field::HasMany,
    orders: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    quantity: Field::Number,
    available_quantity: Field::Number,
    start_t: Field::DateTime,
    end_t: Field::DateTime,
    price_cents: Field::Number,
    allotment: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :event,
    :order_items,
    :orders,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :event,
    :order_items,
    :orders,
    :id,
    :name,
    :description,
    :created_at,
    :updated_at,
    :quantity,
    :available_quantity,
    :start_t,
    :end_t,
    :price_cents,
    :allotment,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :event,
    :order_items,
    :orders,
    :name,
    :description,
    :quantity,
    :available_quantity,
    :start_t,
    :end_t,
    :price_cents,
    :allotment,
  ].freeze

  # Overwrite this method to customize how offers are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(offer)
  #   "Offer ##{offer.id}"
  # end
end
