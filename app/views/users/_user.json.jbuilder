json.extract! user, :id, :name, :address, :contact, :email, :role, :created_at, :updated_at
json.url user_url(user, format: :json)
