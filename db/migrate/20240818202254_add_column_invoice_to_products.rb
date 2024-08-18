class AddColumnInvoiceToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :invoice, null: false, foreign_key: true
  end
end
