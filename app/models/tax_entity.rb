class TaxEntity < ApplicationRecord
has_many :invoices, class_name: "Invoice"
end
