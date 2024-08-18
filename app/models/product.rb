class Product < ApplicationRecord
  belongs_to :invoice, class_name: 'Invoice'
  
end
