class ChangeEmitentAndRecipientInInvoices < ActiveRecord::Migration[7.0]
  def change
    change_table :invoices do |t|
      t.remove :emitent
      t.remove :recipient
      t.references :emitent, null: false, foreign_key: { to_table: :tax_entities }
      t.references :recipient, null: false, foreign_key: { to_table: :tax_entities }
    end
  end
end
