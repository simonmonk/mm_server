class Account < ApplicationRecord


    def Account.current_vat_rate()
        return 20
    end

    # Generate all the transactions and return them along with the 
    # Summary data for theVAT return
    def Account.generateVATReportData(from_date, to_date)
        receipts = []
        Shipment.all.each do | shipment |
            if (shipment.date_payment_received and
                    (shipment.date_payment_received >= from_date) and
                    (shipment.date_payment_received <= to_date) and
                    not shipment.is_amazon())
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
        adjustments = []
        Adjustment.all.each do | adjustment |
            if (adjustment.adjustment_date and
                    (adjustment.adjustment_date >= from_date) and
                    (adjustment.adjustment_date <= to_date))
                adjustments.append(adjustment)
            end
        end

        # will need adjustments here too
        transactions = receipts + payments + adjustments
        transactions = transactions.sort do | a, b |
            a.cash_date <=> b.cash_date
        end
        b1_vatDueSales = 0 # [1]VAT due on sales and other outputs.
        b2_vatDueAcquisitions = 0 # [2]NEGATIVE. VAT due on acquisitions from other EC Member States. 
        b4_vatReclaimedCurrPeriod = 0 # [4]VAT reclaimed on purchases and other inputs (including acquisitions from the EC). 
        b6_totalValueSalesExVAT = 0 # [6]Total value of sales and all other outputs excluding any VAT.
        b7_totalValuePurchasesExVAT = 0 # [7]Total value of purchases and all other inputs excluding any VAT (including exempt purchases).
        b8_totalValueGoodsSuppliedExVAT = 0 # [8]Total value of all supplies of goods and related costs, excluding any VAT, to other EC member states.
        b9_totalAcquisitionsExVAT = 0 # [9]Total value of acquisitions of goods and related costs excluding any VAT, from other EC member states.
        
        transactions.each do | transaction | 
            transaction.vat_action = ""
            # adding and taking away
            if (transaction.is_income)
                # Sales (Outputs)
                b6_totalValueSalesExVAT += transaction.without_vat
                if (transaction.tax_region == 'EU')
                    # EU sales also need to be added to box 8
                    b8_totalValueGoodsSuppliedExVAT += transaction.without_vat
                    transaction.vat_action += " + box 8."
                end
                # Whatever the region the VAT needs adding to b1
                if (transaction.vat)
                    b1_vatDueSales += transaction.vat
                    transaction.vat_action += " + box 1."
                end
            else
                # Purchases (Inputs)
                # for all purchases irrespective of country
                if (transaction.is_vatable)
                    b7_totalValuePurchasesExVAT += transaction.without_vat   
                    b4_vatReclaimedCurrPeriod += transaction.vat
                    transaction.vat_action += " + boxes 4 and 7."
                end
                if (transaction.tax_region == 'EU')
                    b9_totalAcquisitionsExVAT += transaction.without_vat
                    b2_vatDueAcquisitions += transaction.vat
                    # 20% of value for EU purchases added to vatReclaimedCurrPeriod
                    transaction.vat_action += " + boxes 9 and 2."
                end
            end
            transaction.save()
        end
        b3_totalVatDue = b1_vatDueSales + b2_vatDueAcquisitions # [3]Total VAT due (the sum of vatDueSales and vatDueAcquisitions). 
        b5_netVatDue = b3_totalVatDue - b4_vatReclaimedCurrPeriod # [5]The difference between totalVatDue and vatReclaimedCurrPeriod. 
         
        summary_data = {
            periodKey: nil, 
            vatDueSales: b1_vatDueSales, 
            vatDueAcquisitions: b2_vatDueAcquisitions,
            totalVatDue: b3_totalVatDue, 
            vatReclaimedCurrPeriod: b4_vatReclaimedCurrPeriod,
            netVatDue: b5_netVatDue,
            totalValueSalesExVAT: b6_totalValueSalesExVAT,
            totalValuePurchasesExVAT: b7_totalValuePurchasesExVAT,
            totalValueGoodsSuppliedExVAT: b8_totalValueGoodsSuppliedExVAT,
            totalAcquisitionsExVAT: b9_totalAcquisitionsExVAT,
            finalised: true
        }
        return [transactions, summary_data]
    end


end