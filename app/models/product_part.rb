class ProductPart < ApplicationRecord
  belongs_to :part
  belongs_to :product
end
