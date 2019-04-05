require "administrate/base_dashboard"

class CompanyDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    events: Field::HasMany,
    company_finance: Field::HasOne,
    transfers: Field::HasMany,
    users: Field::HasMany,
    bank_account: Field::HasOne,
    address: Field::BelongsTo,
    id: Field::Number,
    name: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    moip_id: Field::String,
    moip_access_token: Field::String,
    business_name: Field::String,
    document_number: Field::String,
    phone_area_code: Field::Number,
    phone_number: Field::Number,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :events,
    :company_finance,
    :transfers,
    :users,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :events,
    :company_finance,
    :transfers,
    :users,
    :bank_account,
    :address,
    :id,
    :name,
    :created_at,
    :updated_at,
    :moip_id,
    :moip_access_token,
    :business_name,
    :document_number,
    :phone_area_code,
    :phone_number,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :events,
    :company_finance,
    :transfers,
    :users,
    :bank_account,
    :address,
    :name,
    :moip_id,
    :moip_access_token,
    :business_name,
    :document_number,
    :phone_area_code,
    :phone_number,
  ].freeze

  # Overwrite this method to customize how companies are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(company)
  #   "Company ##{company.id}"
  # end
end
