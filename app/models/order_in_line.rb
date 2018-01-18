class OrderInLine < ApplicationRecord
    belongs_to :order_in
    belongs_to :part
end
