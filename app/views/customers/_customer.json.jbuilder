json.extract! customer, :id, :Customer_Name, :Customer_Address, :Customer_Contact, :Customer_Email, :payment_term_id, :user_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)
