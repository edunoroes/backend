class AddColumnInvoiceToTaxes < ActiveRecord::Migration[7.1]
  def change
    remove_reference :taxes, :product, foreign_key: true
    add_reference :taxes, :invoice, null: false, foreign_key: true
  end
end
