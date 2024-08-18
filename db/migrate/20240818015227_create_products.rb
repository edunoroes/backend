class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :ncm
      t.string :cfop
      t.string :commercial_unit

      t.timestamps
    end
  end
end
