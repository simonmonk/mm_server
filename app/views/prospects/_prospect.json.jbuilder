json.extract! prospect, :id, :organisation_name, :contact_name, :contact_email, :country, :notes, :account_manager_user_id, :created_at, :updated_at
json.url prospect_url(prospect, format: :json)
