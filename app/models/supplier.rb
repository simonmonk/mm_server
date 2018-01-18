class Supplier < ApplicationRecord
    has_many :part_suppliers
    
    validates :name, presence: true
end
