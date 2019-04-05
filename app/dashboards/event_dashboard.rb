require "administrate/base_dashboard"

class EventDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    company: Field::BelongsTo,
    user: Field::BelongsTo,
    address: Field::BelongsTo,
    offers: Field::HasMany,
    orders: Field::HasMany,
    order_items: Field::HasMany,
    ticket_tokens: Field::HasMany,
    hero_image_attachment: Field::HasOne,
    hero_image_blob: Field::HasOne,
    content_image_attachment: Field::HasOne,
    content_image_blob: Field::HasOne,
    testimonial_images_attachments: Field::HasMany.with_options(class_name: "ActiveStorage::Attachment"),
    testimonial_images_blobs: Field::HasMany.with_options(class_name: "ActiveStorage::Blob"),
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    start_t: Field::DateTime,
    end_t: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    headline: Field::String,
    video: Field::String,
    features: Field::Text,
    invite_text: Field::Text,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :company,
    :user,
    :address,
    :offers,
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :company,
    :user,
    :address,
    :offers,
    :orders,
    :order_items,
    :ticket_tokens,
    :hero_image_attachment,
    :hero_image_blob,
    :content_image_attachment,
    :content_image_blob,
    :testimonial_images_attachments,
    :testimonial_images_blobs,
    :id,
    :name,
    :description,
    :start_t,
    :end_t,
    :created_at,
    :updated_at,
    :headline,
    :video,
    :features,
    :invite_text,
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :company,
    :user,
    :address,
    :offers,
    :orders,
    :order_items,
    :ticket_tokens,
    :hero_image_attachment,
    :hero_image_blob,
    :content_image_attachment,
    :content_image_blob,
    :testimonial_images_attachments,
    :testimonial_images_blobs,
    :name,
    :description,
    :start_t,
    :end_t,
    :headline,
    :video,
    :features,
    :invite_text,
  ].freeze

  # Overwrite this method to customize how events are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(event)
  #   "Event ##{event.id}"
  # end
end
