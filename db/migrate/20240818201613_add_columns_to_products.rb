class AddColumnsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :commercial_quantity, :float
    add_column :products, :unit_value, :float
  end
end
