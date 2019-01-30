json.extract! communication, :id, :prospect_id, :communication_date, :user_id, :notes, :email_url, :created_at, :updated_at
json.url communication_url(communication, format: :json)
