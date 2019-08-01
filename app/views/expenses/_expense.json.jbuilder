json.extract! expense, :id, :incurred_date, :reimbursed_date, :user_id, :account_id, :supplier, :description, :without_vat, :vat, :with_vat, :is_mileage, :miles, :mileage_rate, :created_at, :updated_at
json.url expense_url(expense, format: :json)
