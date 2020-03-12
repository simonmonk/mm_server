class AdjustmentType < ApplicationRecord

    has_many :adjustments

    def AdjustmentType.for_code(c)
        return AdjustmentType.find_by(code: c)
    end
    
    # Run this to migrate adjustments with an adjustment type as a string in the field adjustment_type
    # into a reference to an AdjustmentType object with the same name
    def AdjustmentType.migrate_string_adjustment_types()
        adjustments = Adjustment.all
        adjustments.each do | adjustment |
            if (not adjustment.adjustment_type_id or adjustment.adjustment_type_id == 0)
                puts "******** Found adjustment to migrate ********* " + adjustment.id.to_s
                adjustment_type = AdjustmentType.find_by(name: adjustment.adjustment_type)
                if (not adjustment_type)
                    puts "ERROR: Couldn't find adjustmentType matching:" + adjustment.adjustment_type
                else
                    puts "setting adjustemnt type to object:" + adjustment_type.name
                    adjustment.adjustment_type_id = adjustment_type.id
                    adjustment.save
                end
            end
        end
    end


    def default_account()
        # some adjustments may not have an account unless Amazon becomes an account
        if (code == 'HMRC' || code == 'REIMBURSEMENT' || code == 'AMAZON_FEES')
            return Account.for_code('CUR')
        else
            return nil
        end
    end

end
