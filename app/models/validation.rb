class Validation < ApplicationRecord
  belongs_to :user
  belongs_to :ticket_token

end
