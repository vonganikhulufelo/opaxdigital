json.extract! supplier, :id, :Supplier_Name, :Supplier_Address, :Supplier_Contact, :Supplier_Email, :payment_term_id, :user_id, :created_at, :updated_at
json.url supplier_url(supplier, format: :json)
