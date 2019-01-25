class Validation < ApplicationRecord
  belongs_to :user
  has_one :ticket_token
end
