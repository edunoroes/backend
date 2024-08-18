class CreateTaxEntities < ActiveRecord::Migration[7.1]
  def change
    create_table :tax_entities do |t|
      t.string :cnpj, null: false 
      t.string :name, null: false 
      t.string :address, null: false  
      t.string :number, null: false  
      t.string :neighborhood, null: false  
      t.string :city, null: false  
      t.string :state, null: false  
      t.string :postal_code, null: false 
    end
  end
end
