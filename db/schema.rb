# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180426100112) do

  create_table "assemblies", force: :cascade do |t|
    t.string   "name"
    t.integer  "qty"
    t.decimal  "labour",              precision: 10, scale: 3
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "stock_warning_level"
    t.boolean  "active"
  end

  create_table "assembly_parts", force: :cascade do |t|
    t.integer  "qty"
    t.integer  "part_id"
    t.integer  "assembly_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["assembly_id"], name: "index_assembly_parts_on_assembly_id"
    t.index ["part_id"], name: "index_assembly_parts_on_part_id"
  end

  create_table "currencies", force: :cascade do |t|
    t.string   "name"
    t.string   "symbol"
    t.decimal  "per_pound",  precision: 10, scale: 2
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.boolean  "dismissed"
    t.text     "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "priority"
  end

  create_table "order_in_lines", force: :cascade do |t|
    t.integer  "qty"
    t.integer  "order_in_id"
    t.integer  "part_id"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.decimal  "price",              precision: 10, scale: 3
    t.integer  "qty_in"
    t.date     "date_line_received"
    t.index ["order_in_id"], name: "index_order_in_lines_on_order_in_id"
    t.index ["part_id"], name: "index_order_in_lines_on_part_id"
  end

  create_table "order_ins", force: :cascade do |t|
    t.boolean  "open"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.date     "placed_date"
    t.integer  "supplier_id"
    t.text     "notes"
    t.string   "currency"
    t.decimal  "exch_rate",          precision: 10, scale: 3
    t.decimal  "shipping",           precision: 10, scale: 3
    t.date     "date_qr_sent"
    t.string   "vat_info_collected"
    t.date     "quotation_received"
  end

  create_table "part_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "part_suppliers", force: :cascade do |t|
    t.string   "url"
    t.integer  "part_id"
    t.integer  "supplier_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "code"
    t.index ["part_id"], name: "index_part_suppliers_on_part_id"
    t.index ["supplier_id"], name: "index_part_suppliers_on_supplier_id"
  end

  create_table "parts", force: :cascade do |t|
    t.string   "name"
    t.integer  "qty"
    t.decimal  "cost",                precision: 10, scale: 3
    t.string   "currency"
    t.decimal  "exch_rate",           precision: 10, scale: 3
    t.datetime "created_at",                                                  null: false
    t.datetime "updated_at",                                                  null: false
    t.integer  "stock_warning_level"
    t.boolean  "active",                                       default: true
    t.decimal  "shipping_cost",       precision: 10, scale: 3
    t.text     "notes"
    t.integer  "part_category_id"
  end

  create_table "product_assemblies", force: :cascade do |t|
    t.integer  "qty"
    t.integer  "product_id"
    t.integer  "assembly_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["assembly_id"], name: "index_product_assemblies_on_assembly_id"
    t.index ["product_id"], name: "index_product_assemblies_on_product_id"
  end

  create_table "product_parts", force: :cascade do |t|
    t.integer  "part_id"
    t.integer  "product_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "fieldname"
    t.integer  "qty"
    t.index ["part_id"], name: "index_product_parts_on_part_id"
    t.index ["product_id"], name: "index_product_parts_on_product_id"
  end

  create_table "product_retailers", force: :cascade do |t|
    t.string   "url"
    t.integer  "product_id"
    t.integer  "retailer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "warn_qty"
    t.float    "weekly_sales_avg"
    t.string   "sku"
    t.index ["product_id"], name: "index_product_retailers_on_product_id"
    t.index ["retailer_id"], name: "index_product_retailers_on_retailer_id"
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.integer  "qty"
    t.datetime "created_at",                                                      null: false
    t.datetime "updated_at",                                                      null: false
    t.string   "sku"
    t.decimal  "labour",                  precision: 10, scale: 3
    t.integer  "stock_warning_level"
    t.boolean  "active",                                           default: true
    t.decimal  "wholesale_price",         precision: 10, scale: 3
    t.decimal  "retail_price",            precision: 10, scale: 3
    t.text     "notes"
    t.decimal  "wholesale_price_usd",     precision: 10, scale: 3
    t.decimal  "retail_price_usd",        precision: 10, scale: 3
    t.string   "harmoized_tarrif_number"
    t.string   "country_of_origin"
    t.text     "short_description"
    t.text     "long_description"
    t.text     "product_photo_uri"
    t.string   "customs_description"
    t.boolean  "include_in_catalog"
    t.string   "product_url"
    t.decimal  "weight_g",                precision: 10, scale: 3
  end

  create_table "retailers", force: :cascade do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.text     "notes"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "regex_qty"
    t.string   "regex_oos"
    t.string   "fao_billing"
    t.string   "billing_ad_line1"
    t.string   "billing_ad_line2"
    t.string   "billing_ad_city"
    t.string   "billing_ad_postal_code"
    t.string   "billing_ad_country"
    t.string   "billing_ad_tel"
    t.string   "fao_delivery"
    t.string   "delivery_ad_line1"
    t.string   "delivery_ad_line2"
    t.string   "delivery_ad_city"
    t.string   "delivery_ad_postal_code"
    t.string   "delivery_ad_country"
    t.string   "delivery_ad_tel"
    t.boolean  "vatable"
    t.string   "vat_number"
    t.string   "pref_shipping_provider"
    t.string   "pref_shipping_provider_ac_no"
    t.string   "pref_currency"
    t.string   "billing_ad_state"
    t.string   "delivery_ad_state"
    t.boolean  "active"
    t.boolean  "show_foreign_sku"
  end

  create_table "sales", force: :cascade do |t|
    t.integer  "week"
    t.integer  "count"
    t.decimal  "value",       precision: 10, scale: 3
    t.integer  "product_id"
    t.integer  "retailer_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["product_id"], name: "index_sales_on_product_id"
    t.index ["retailer_id"], name: "index_sales_on_retailer_id"
  end

  create_table "shipment_products", force: :cascade do |t|
    t.integer  "shipment_id"
    t.integer  "product_id"
    t.integer  "qty"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["product_id"], name: "index_shipment_products_on_product_id"
    t.index ["shipment_id"], name: "index_shipment_products_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.integer  "retailer_id"
    t.date     "dispatched"
    t.text     "notes"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "stock_subtracted"
    t.string   "retailer_shipment_id"
    t.date     "date_order_received"
    t.date     "date_dispatched"
    t.date     "date_invoice_sent"
    t.date     "date_payment_reminder"
    t.string   "order_email_link"
    t.string   "po_reference"
    t.string   "invoice_number"
    t.decimal  "shipping_cost",           precision: 10, scale: 3
    t.string   "shipping_provider"
    t.string   "shipping_provider_ac_no"
    t.decimal  "discount",                precision: 10, scale: 3
    t.date     "date_payment_received"
    t.decimal  "vat_rate",                precision: 10, scale: 3
    t.index ["retailer_id"], name: "index_shipments_on_retailer_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string   "name"
    t.string   "contact_name"
    t.string   "contact_email"
    t.text     "notes"
    t.string   "text"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "regex_qty"
    t.string   "regex_oos"
    t.string   "website"
    t.string   "login_details"
    t.string   "payment_details"
    t.boolean  "active"
  end

  create_table "transactions", force: :cascade do |t|
    t.string   "transaction_time"
    t.string   "transaction_type"
    t.text     "description"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

end
