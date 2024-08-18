class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :ncm, null: false
      t.string :cfop, null: false
      t.string :commercial_unit, null: false
      t.decimal :commercial_quantity, precision: 10, scale: 4, null: false
      t.decimal :unit_value, precision: 15, scale: 10, null: false

      t.references :invoice, null: false, foreign_key: true

      t.timestamps
    end
  end
end
