class CreateInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :invoices do |t|
      t.string :series, null: false
      t.string :invoice_number, null: false
      t.datetime :issue_datetime, null: false
      t.string :emitent, null: false
      t.string :recipient, null: false

      t.timestamps
    end
  end
end
