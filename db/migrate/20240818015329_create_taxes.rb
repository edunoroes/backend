class CreateTaxes < ActiveRecord::Migration[7.0]
  def change
    create_table :taxes do |t|
      t.decimal :icms_value, precision: 15, scale: 2, null: false
      t.decimal :ipi_value, precision: 15, scale: 2, null: false
      t.decimal :pis_value, precision: 15, scale: 2, null: false
      t.decimal :cofins_value, precision: 15, scale: 2, null: false

      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end