require "administrate/base_dashboard"

class BankAccountDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    company_finance: Field::HasOne,
    transfers: Field::HasMany,
    company: Field::HasOne,
    id: Field::Number,
    moip_id: Field::String,
    legal_name: Field::String,
    document_type: Field::String,
    document_number: Field::String,
    bank_code: Field::String,
    agency_number: Field::String,
    agency_check_number: Field::String,
    account_number: Field::String,
    account_type: Field::String,
    account_check_number: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :company_finance,
    :transfers,
    :company,
    :id,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :company_finance,
    :transfers,
    :company,
    :id,
    :moip_id,
    :legal_name,
    :document_type,
    :document_number,
    :bank_code,
    :agency_number,
    :agency_check_number,
    :account_number,
    :account_type,
    :account_check_number,
    :created_at,
    :updated_at,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :company_finance,
    :transfers,
    :company,
    :moip_id,
    :legal_name,
    :document_type,
    :document_number,
    :bank_code,
    :agency_number,
    :agency_check_number,
    :account_number,
    :account_type,
    :account_check_number,
  ].freeze

  # Overwrite this method to customize how bank accounts are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(bank_account)
  #   "BankAccount ##{bank_account.id}"
  # end
end
