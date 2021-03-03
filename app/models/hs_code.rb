class HsCode < ApplicationRecord

    has_many :products

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

    def summary
        return code + " (" + nickname.to_s + ")"
    end

end
