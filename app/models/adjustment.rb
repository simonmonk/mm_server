class Adjustment < ApplicationRecord

    def Adjustment.types()
        return ['Overpayment', 'Underpayment']
    end

end
