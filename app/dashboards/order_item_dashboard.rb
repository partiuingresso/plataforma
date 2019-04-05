require "administrate/base_dashboard"

class OrderItemDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    offer: Field::BelongsTo,
    order: Field::BelongsTo,
    ticket_tokens: Field::HasMany,
    event: Field::HasOne,
    user: Field::HasOne,
    id: Field::Number,
    quantity: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :offer,
    :order,
    :ticket_tokens,
    :event,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :offer,
    :order,
    :ticket_tokens,
    :event,
    :user,
    :id,
    :quantity,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :offer,
    :order,
    :ticket_tokens,
    :event,
    :user,
    :quantity,
  ].freeze

  # Overwrite this method to customize how order items are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(order_item)
  #   "OrderItem ##{order_item.id}"
  # end
end
