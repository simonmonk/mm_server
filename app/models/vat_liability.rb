class VatLiability < ApplicationRecord

    def status_string
        if (status == 'F')
            return "Fulfilled"
        elsif (status == 'O')
            return "Open"
        else
            return "unknown"
        end
    end

    def calc_vat_return()
        result = Account.generateVATReportData(start_date, end_date)
        summary = result[1]
        return summary.as_json
    end

    def as_json(options={})
        super(:methods => [:status_string ])
    end  


end
