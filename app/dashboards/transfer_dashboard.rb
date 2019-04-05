require "administrate/base_dashboard"

class TransferDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    company: Field::BelongsTo,
    bank_account: Field::BelongsTo,
    id: Field::Number,
    amount_cents: Field::Number,
    fee_cents: Field::Number,
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
    :company,
    :bank_account,
    :id,
    :amount_cents,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :company,
    :bank_account,
    :id,
    :amount_cents,
    :fee_cents,
    :created_at,
    :updated_at,
    :status,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :company,
    :bank_account,
    :amount_cents,
    :fee_cents,
    :status,
  ].freeze

  # Overwrite this method to customize how transfers are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(transfer)
  #   "Transfer ##{transfer.id}"
  # end
end
