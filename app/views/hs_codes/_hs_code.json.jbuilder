json.extract! hs_code, :id, :code, :nickname, :description, :url, :notes, :created_at, :updated_at
json.url hs_code_url(hs_code, format: :json)
