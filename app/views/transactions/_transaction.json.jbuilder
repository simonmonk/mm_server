json.extract! transaction, :id, :transaction_time, :transaction_type, :description, :created_at, :updated_at
json.url transaction_url(transaction, format: :json)
