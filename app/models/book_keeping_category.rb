class BookKeepingCategory < ApplicationRecord

    # Description (can change)  Code    Is a VAT Input
    #                           (fixed) (box 7)    
    # ------------------------------------------------
    # Materials (Parts)	        PAR	    Y        
    # Materials (General)	    MAT	    Y
    # Equipment and Furnature	EQU	    Y
    # Packaging	                PACK	Y
    # Stationary	            STAT	Y
    # Software and IT	        SOFT	Y
    # Bank Charges	            BANK	N
    # PayPal Fees	            PPFEES	N
    # Accountancy	            ACC	    Y
    # Professional Services	    PS	    Y
    # Shipping	                SHIP	Y
    # Postage (P.O.) exempt	    POST	Y
    # Insurance	                INS	    Y
    # Wages & PAYE	            WAG	    N
    # Property Costs	        PROP	Y
    # Subsistance	            SUBS	Y
    # Directors Salary	        DIR	    N
    # HMRC	                    HMRC	N

    def is_vat_input_category()
        cat_codes = ['PAR', 'MAT', 'EQU', 'PACK', 'STAT', 'SOFT', 'ACC', 'PS', 'SHIP', 'POST', 'INS', 'PROP', 'SUBS'] 
        return cat_codes.include?(code)
    end


end
