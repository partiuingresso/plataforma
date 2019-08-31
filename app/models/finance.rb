class Finance < ApplicationRecord
  belongs_to :seller
  belongs_to :bank_account

  accepts_nested_attributes_for :bank_account

  validates_associated :bank_account
end
