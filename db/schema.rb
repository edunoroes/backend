# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_08_18_015347) do
  create_table "allowlisted_jwts", force: :cascade do |t|
    t.string "jti", null: false
    t.string "aud"
    t.datetime "exp", null: false
    t.integer "your_user_table_id", null: false
    t.index ["jti"], name: "index_allowlisted_jwts_on_jti", unique: true
    t.index ["your_user_table_id"], name: "index_allowlisted_jwts_on_your_user_table_id"
  end

  create_table "documents", force: :cascade do |t|
    t.string "file"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_documents_on_user_id"
  end

  create_table "invoices", force: :cascade do |t|
    t.string "series", null: false
    t.string "invoice_number", null: false
    t.datetime "issue_datetime", null: false
    t.string "emitent", null: false
    t.string "recipient", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.string "ncm"
    t.string "cfop"
    t.string "commercial_unit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "summaries", force: :cascade do |t|
    t.decimal "total_product_value", precision: 15, scale: 2, null: false
    t.decimal "total_tax_value", precision: 15, scale: 2, null: false
    t.integer "invoice_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_summaries_on_invoice_id"
  end

  create_table "taxes", force: :cascade do |t|
    t.decimal "icms_value", precision: 15, scale: 2, null: false
    t.decimal "ipi_value", precision: 15, scale: 2, null: false
    t.decimal "pis_value", precision: 15, scale: 2, null: false
    t.decimal "cofins_value", precision: 15, scale: 2, null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_taxes_on_product_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jti"
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "allowlisted_jwts", "your_user_tables", on_delete: :cascade
  add_foreign_key "documents", "users"
  add_foreign_key "summaries", "invoices"
  add_foreign_key "taxes", "products"
end
