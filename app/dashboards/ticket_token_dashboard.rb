require "administrate/base_dashboard"

class TicketTokenDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    validation: Field::HasOne,
    order_item: Field::BelongsTo,
    order: Field::HasOne,
    user: Field::HasOne,
    offer: Field::HasOne,
    event: Field::HasOne,
    id: Field::Number,
    code: Field::String,
    owner_name: Field::String,
    owner_email: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    status: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :validation,
    :order_item,
    :order,
    :user,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :validation,
    :order_item,
    :order,
    :user,
    :offer,
    :event,
    :id,
    :code,
    :owner_name,
    :owner_email,
    :created_at,
    :updated_at,
    :status,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :validation,
    :order_item,
    :order,
    :user,
    :offer,
    :event,
    :code,
    :owner_name,
    :owner_email,
    :status,
  ].freeze

  # Overwrite this method to customize how ticket tokens are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(ticket_token)
  #   "TicketToken ##{ticket_token.id}"
  # end
end
