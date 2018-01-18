class ProductAssembly < ApplicationRecord
  belongs_to :product
  belongs_to :assembly
end
