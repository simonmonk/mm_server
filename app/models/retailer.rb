class Retailer < ApplicationRecord
    has_many :product_retailers
    has_many :shipments
    has_many :products
    validates :name, presence: true
end
