class Company < ApplicationRecord
    has_many :events
    has_one :company_finance
    has_many :users
end
