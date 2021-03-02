class HsCode < ApplicationRecord

    def used_in_products
        msg = ""
        Product.all.each do | product |
            hs = product.harmoized_tarrif_number.strip
            if (hs == self.code)
                msg += product.name + ", "
            end
        end
        return msg
    end

end
