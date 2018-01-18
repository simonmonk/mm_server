class OrderIn < ApplicationRecord
  belongs_to :supplier
  has_many :order_in_lines
end
