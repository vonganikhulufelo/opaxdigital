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

ActiveRecord::Schema.define(version: 2019_05_30_102509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "c_pay_m_districts", force: :cascade do |t|
    t.string "magisterialdistrict_zone"
    t.string "magisterialdistrict_district"
    t.string "magisterialdistrict_code"
    t.bigint "magisterial_district_id"
    t.bigint "customer_payment_term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_payment_term_id"], name: "index_c_pay_m_districts_on_customer_payment_term_id"
    t.index ["magisterial_district_id"], name: "index_c_pay_m_districts_on_magisterial_district_id"
  end

  create_table "c_pay_m_product_prices", force: :cascade do |t|
    t.decimal "product_price_price", precision: 38, scale: 4, default: "0.0"
    t.string "product_pescription_product"
    t.decimal "product_rebate", precision: 38, scale: 4, default: "0.0"
    t.decimal "net_price", precision: 38, scale: 4, default: "0.0"
    t.decimal "s_net_price", precision: 38, scale: 4, default: "0.0"
    t.string "s_name"
    t.decimal "gross_price", precision: 38, scale: 4, default: "0.0"
    t.decimal "claw_margin", precision: 38, scale: 4, default: "0.0"
    t.string "s_zone"
    t.string "s_payment"
    t.string "uid"
    t.bigint "product_description_id"
    t.bigint "product_price_id"
    t.bigint "c_pay_m_district_id"
    t.bigint "supplier_id"
    t.bigint "s_pay_m_product_price_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["c_pay_m_district_id"], name: "index_c_pay_m_product_prices_on_c_pay_m_district_id"
    t.index ["product_description_id"], name: "index_c_pay_m_product_prices_on_product_description_id"
    t.index ["product_price_id"], name: "index_c_pay_m_product_prices_on_product_price_id"
    t.index ["s_pay_m_product_price_id"], name: "index_c_pay_m_product_prices_on_s_pay_m_product_price_id"
    t.index ["supplier_id"], name: "index_c_pay_m_product_prices_on_supplier_id"
  end

  create_table "customer_payment_terms", force: :cascade do |t|
    t.string "payment_term_description"
    t.integer "payment_term_threshold"
    t.bigint "payment_term_id"
    t.bigint "customer_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_payment_terms_on_customer_id"
    t.index ["payment_term_id"], name: "index_customer_payment_terms_on_payment_term_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "customer_name"
    t.string "location"
    t.string "customer_address"
    t.string "customer_contact"
    t.string "customer_email"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string "description"
    t.string "uid"
    t.string "username"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "magisterial_districts", force: :cascade do |t|
    t.string "magisterialdistrict_zone"
    t.string "magisterialdistrict_district"
    t.string "magisterialdistrict_code"
    t.string "magisterialdistrict_province"
    t.string "uid"
    t.bigint "user_id"
    t.bigint "zone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_magisterial_districts_on_user_id"
    t.index ["zone_id"], name: "index_magisterial_districts_on_zone_id"
  end

  create_table "payment_terms", force: :cascade do |t|
    t.string "paymentterm_description"
    t.string "paymentterm_threshold"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_terms_on_user_id"
  end

  create_table "product_descriptions", force: :cascade do |t|
    t.string "productdescription_product"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_product_descriptions_on_user_id"
  end

  create_table "product_prices", force: :cascade do |t|
    t.datetime "productprice_month_id"
    t.string "productprice_zone_class"
    t.decimal "productprice_price", precision: 38, scale: 4, default: "0.0"
    t.string "productdescription_product"
    t.string "uid"
    t.bigint "product_description_id"
    t.bigint "user_id"
    t.bigint "zone_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_description_id"], name: "index_product_prices_on_product_description_id"
    t.index ["user_id"], name: "index_product_prices_on_user_id"
    t.index ["zone_id"], name: "index_product_prices_on_zone_id"
  end

  create_table "purchase_order_products", force: :cascade do |t|
    t.integer "product_id"
    t.datetime "delivered_date"
    t.string "product_name"
    t.decimal "zone_price", precision: 38, scale: 4, default: "0.0"
    t.integer "order_quantity"
    t.decimal "order_value", precision: 38, scale: 4, default: "0.0"
    t.decimal "purchase_price", precision: 38, scale: 4, default: "0.0"
    t.decimal "pick_up_value", precision: 38, scale: 4, default: "0.0"
    t.bigint "purchase_order_id"
    t.integer "pick_up_quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_order_id"], name: "index_purchase_order_products_on_purchase_order_id"
  end

  create_table "purchase_orders", force: :cascade do |t|
    t.datetime "order_date"
    t.string "system__internal_reference"
    t.string "internal_po_reference"
    t.string "vendor_name"
    t.string "vendor_payment"
    t.string "product_pescription_product"
    t.decimal "product_price_price", precision: 38, scale: 4, default: "0.0"
    t.decimal "net_price", precision: 38, scale: 4, default: "0.0"
    t.string "order_qty"
    t.decimal "order_value", precision: 38, scale: 4, default: "0.0"
    t.string "vendor_reference"
    t.string "vendor_documentation"
    t.datetime "pick_up_date_time"
    t.integer "pick_up_qt"
    t.decimal "pick_up_value", precision: 38, scale: 4, default: "0.0"
    t.decimal "total_order_value", precision: 38, scale: 4, default: "0.0"
    t.decimal "total_delivered_value", precision: 38, scale: 4, default: "0.0"
    t.string "bol_reference"
    t.string "status"
    t.string "uid"
    t.string "recon_status"
    t.string "zone"
    t.integer "zone_id"
    t.integer "vendor_id"
    t.integer "payment_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_purchase_orders_on_user_id"
  end

  create_table "s_pay_m_districts", force: :cascade do |t|
    t.string "magisterialdistrict_zone"
    t.string "magisterialdistrict_district"
    t.string "magisterialdistrict_code"
    t.bigint "magisterial_district_id"
    t.bigint "supplier_payment_term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["magisterial_district_id"], name: "index_s_pay_m_districts_on_magisterial_district_id"
    t.index ["supplier_payment_term_id"], name: "index_s_pay_m_districts_on_supplier_payment_term_id"
  end

  create_table "s_pay_m_product_prices", force: :cascade do |t|
    t.string "product_price_price"
    t.string "product_pescription_product"
    t.decimal "product_rebate", precision: 38, scale: 4, default: "0.0"
    t.decimal "net_price", precision: 38, scale: 4, default: "0.0"
    t.decimal "claw_margin", precision: 38, scale: 4, default: "0.0"
    t.string "uid"
    t.bigint "product_description_id"
    t.bigint "product_price_id"
    t.bigint "s_pay_m_district_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_description_id"], name: "index_s_pay_m_product_prices_on_product_description_id"
    t.index ["product_price_id"], name: "index_s_pay_m_product_prices_on_product_price_id"
    t.index ["s_pay_m_district_id"], name: "index_s_pay_m_product_prices_on_s_pay_m_district_id"
  end

  create_table "sales_order_products", force: :cascade do |t|
    t.string "product_name"
    t.integer "product_id"
    t.integer "order_quantity"
    t.decimal "order_rate", precision: 38, scale: 4, default: "0.0"
    t.decimal "order_value", precision: 38, scale: 4, default: "0.0"
    t.datetime "delivered_date"
    t.integer "delivery_quantity"
    t.decimal "delivery_rate", precision: 38, scale: 4, default: "0.0"
    t.decimal "delivery_value", precision: 38, scale: 4, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sales_orders", force: :cascade do |t|
    t.datetime "delivered_date"
    t.string "customer_name"
    t.integer "customer_id"
    t.string "zone"
    t.integer "zone_id"
    t.string "payment"
    t.integer "payment_id"
    t.boolean "invoice", default: false
    t.string "puma_reference"
    t.string "delivery_note_reference"
    t.string "delivery_attachment"
    t.string "status"
    t.string "recon"
    t.string "uid"
    t.datetime "delivery_date_on_delivery"
    t.decimal "total_delivery_value", precision: 38, scale: 4, default: "0.0"
    t.decimal "total_order_value", precision: 38, scale: 4, default: "0.0"
    t.datetime "order_date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sales_orders_on_user_id"
  end

  create_table "supplier_payment_terms", force: :cascade do |t|
    t.string "payment_term_description"
    t.string "payment_term_threshold"
    t.bigint "supplier_id"
    t.bigint "payment_term_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_term_id"], name: "index_supplier_payment_terms_on_payment_term_id"
    t.index ["supplier_id"], name: "index_supplier_payment_terms_on_supplier_id"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "supplier_name"
    t.string "supplier_address"
    t.string "supplier_contact"
    t.string "supplier_email"
    t.string "uid"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_suppliers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.string "address"
    t.string "contact"
    t.string "name"
    t.string "uid"
    t.string "role"
    t.string "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
  end

  create_table "zones", force: :cascade do |t|
    t.string "zone_description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_zones_on_user_id"
  end

  add_foreign_key "c_pay_m_districts", "customer_payment_terms"
  add_foreign_key "c_pay_m_districts", "magisterial_districts"
  add_foreign_key "c_pay_m_product_prices", "c_pay_m_districts"
  add_foreign_key "c_pay_m_product_prices", "product_descriptions"
  add_foreign_key "c_pay_m_product_prices", "product_prices"
  add_foreign_key "c_pay_m_product_prices", "s_pay_m_product_prices"
  add_foreign_key "c_pay_m_product_prices", "suppliers"
  add_foreign_key "customer_payment_terms", "customers"
  add_foreign_key "customer_payment_terms", "payment_terms"
  add_foreign_key "customers", "users"
  add_foreign_key "logs", "users"
  add_foreign_key "magisterial_districts", "users"
  add_foreign_key "magisterial_districts", "zones"
  add_foreign_key "payment_terms", "users"
  add_foreign_key "product_descriptions", "users"
  add_foreign_key "product_prices", "product_descriptions"
  add_foreign_key "product_prices", "users"
  add_foreign_key "product_prices", "zones"
  add_foreign_key "purchase_order_products", "purchase_orders"
  add_foreign_key "purchase_orders", "users"
  add_foreign_key "s_pay_m_districts", "magisterial_districts"
  add_foreign_key "s_pay_m_districts", "supplier_payment_terms"
  add_foreign_key "s_pay_m_product_prices", "product_descriptions"
  add_foreign_key "s_pay_m_product_prices", "product_prices"
  add_foreign_key "s_pay_m_product_prices", "s_pay_m_districts"
  add_foreign_key "sales_orders", "users"
  add_foreign_key "supplier_payment_terms", "payment_terms"
  add_foreign_key "supplier_payment_terms", "suppliers"
  add_foreign_key "suppliers", "users"
  add_foreign_key "zones", "users"
end
