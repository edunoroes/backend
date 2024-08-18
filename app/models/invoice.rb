class Invoice < ApplicationRecord
  belongs_to :user
  has_many :products, dependent: :destroy
  has_many :taxes , class_name: 'Taxe'
  belongs_to :recipient, class_name: 'TaxEntity', foreign_key: 'recipient_id'
  belongs_to :emitent, class_name: 'TaxEntity', foreign_key: 'emitent_id'
end
