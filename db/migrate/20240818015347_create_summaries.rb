class CreateSummaries < ActiveRecord::Migration[7.0]
  def change
    create_table :summaries do |t|
      t.decimal :total_product_value, precision: 15, scale: 2, null: false
      t.decimal :total_tax_value, precision: 15, scale: 2, null: false

      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end