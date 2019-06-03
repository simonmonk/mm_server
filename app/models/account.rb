class Account < ApplicationRecord

    # Generate all the transactions and return them along with the 
    # Summary data for theVAT return
    def Account.generateVATReportData(from_date, to_date)
        receipts = []
        Shipment.all.each do | shipment |
            if (shipment.date_payment_received and
                    (shipment.date_payment_received >= from_date) and
                    (shipment.date_payment_received <= to_date))
                receipts.append(shipment)
            end
        end
        payments = []
        OrderIn.all.each do | payment |
            if (payment.date_payment_made and
                    (payment.date_payment_made >= from_date) and
                    (payment.date_payment_made <= to_date))
                payments.append(payment)
            end
        end
        transactions = receipts + payments
        transactions = transactions.sort do | a, b |
            a.cash_date <=> b.cash_date
        end
        vatDueSales = 0 # [1]VAT due on sales and other outputs.
        vatDueAcquisitions = 0 # [2]NEGATIVE. VAT due on acquisitions from other EC Member States. 
        totalValueSalesExVAT = 0 # [6]Total value of sales and all other outputs excluding any VAT.
        totalValuePurchasesExVAT = 0 # [7]Total value of purchases and all other inputs excluding any VAT (including exempt purchases).
        transactions.each do | transaction | 
            # adding and taking away
            if (transaction.is_income)
                totalValueSalesExVAT += transaction.without_vat
                vatDueSales += transaction.vat
            else
                # not all payments contribute to purchase VAT
                # Must have VAT invoice
                # Imports from outside the EU - E.g. PCBWay. from the courier (field on OrderIn??)
                totalValuePurchasesExVAT += transaction.without_vat

                if (transaction.supplier.tax_region == 'EU')
                    vatDueAcquisitions += transaction.vat
                end
            end
        end
        totalVatDue = vatDueSales + vatDueAcquisitions # [3]Total VAT due (the sum of vatDueSales and vatDueAcquisitions). 
        vatReclaimedCurrPeriod = 0 # [4]VAT reclaimed on purchases and other inputs (including acquisitions from the EC). 
        netVatDue = totalVatDue - vatReclaimedCurrPeriod # [5]The difference between totalVatDue and vatReclaimedCurrPeriod. 
        totalValueGoodsSuppliedExVAT = 0 # [8]Total value of all supplies of goods and related costs, excluding any VAT, to other EC member states. 
        totalAcquisitionsExVAT = 0 # [9]Total value of acquisitions of goods and related costs excluding any VAT, from other EC member states.
        summary_data = {
            periodKey: nil, 
            vatDueSales: vatDueSales, 
            vatDueAcquisitions: vatDueAcquisitions,
            totalVatDue: totalVatDue, 
            vatReclaimedCurrPeriod: vatReclaimedCurrPeriod,
            netVatDue: netVatDue,
            totalValueSalesExVAT: totalValueSalesExVAT,
            totalValuePurchasesExVAT: totalValuePurchasesExVAT,
            totalValueGoodsSuppliedExVAT: totalValueGoodsSuppliedExVAT,
            totalAcquisitionsExVAT: totalAcquisitionsExVAT,
            finalised: true
        }
        return [transactions, summary_data]
    end


end