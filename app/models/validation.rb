class Validation < ApplicationRecord
  belongs_to :user
  belongs_to :ticket_token, autosave: true

end
