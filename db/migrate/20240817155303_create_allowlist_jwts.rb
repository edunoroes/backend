class CreateAllowlistJwts < ActiveRecord::Migration[7.1]
  create_table :allowlisted_jwts do |t|
    t.string :jti, null: false
    t.string :aud
    t.datetime :exp, null: false
    t.references :your_user_table, foreign_key: { on_delete: :cascade }, null: false
  end

  add_index :allowlisted_jwts, :jti, unique: true
end
