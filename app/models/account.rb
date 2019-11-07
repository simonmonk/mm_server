class Account < ApplicationRecord


    def Account.current_vat_rate()
        v = Setting.get_setting('CURRENT_VAT_RATE')
        if (v)
            return v.to_f
        else
            puts "add a setting for CURRENT_VAT_RATE at /settings"
            return 20
        end
    end

    def Account.for_code(c)
        return Account.find_by(code: c)
    end

    # Generate all the transactions and return them along with the 
    # Summary data for theVAT return
    def Account.generateVATReportData(from_date, to_date)
        receipts = []
        Shipment.all.each do | shipment |
            if (shipment.accounting_date and
                    (shipment.accounting_date >= from_date) and
                    (shipment.accounting_date <= to_date) and
                    not shipment.is_amazon())
                receipts.append(shipment)
            end
        end
        payments = []
        OrderIn.all.each do | payment |
            if (payment.accounting_date and
                    (payment.accounting_date >= from_date) and
                    (payment.accounting_date <= to_date))
                payments.append(payment)
            end
        end
        adjustments = []
        Adjustment.all.each do | adjustment |
            if (adjustment.accounting_date and
                    (adjustment.accounting_date >= from_date) and
                    (adjustment.accounting_date <= to_date) and
                    (adjustment.accounting_date != 'Actual Income from Amazon'))
                adjustments.append(adjustment)
            end
        end
        expenses = []
        Expense.all.each do | expense |
            if (expense.accounting_date and
                    (expense.accounting_date >= from_date) and
                    (expense.accounting_date <= to_date))
                puts "**** found expense"
                expenses.append(expense)
            end
        end

        # will need adjustments here too
        transactions = receipts + payments + adjustments + expenses
        transactions = transactions.sort do | a, b |
            a.accounting_date <=> b.accounting_date
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
            if (transaction.is_income and transaction.transaction_type != 'Transfer' and transaction.transaction_type != 'HMRC Adjustment')
                # Sales (Outputs)
                b6_totalValueSalesExVAT += transaction.without_vat
                if (transaction.tax_region == 'EU')
                    # EU sales also need to be added to box 8
                    b8_totalValueGoodsSuppliedExVAT += transaction.without_vat      # Podconsult overpayment Adjustment went in boxes 1 and 6 but should go into box 8 as well but it didn't
                    transaction.vat_action += " + box 8 and 6"                      # This is because Adjustment doesn't know its tax region - add to db and UI
                end
                # Whatever the region the VAT needs adding to b1
                if (transaction.vat)
                    b1_vatDueSales += transaction.vat
                    transaction.vat_action += " + box 1 and 6"
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
                    b2_vatDueAcquisitions += transaction.vat
                    transaction.vat_action += " + box 2."
                end
                if (transaction.tax_region == 'EU' and transaction.transaction_type == 'ORDER_IN' and not transaction.is_service)     
                    b9_totalAcquisitionsExVAT += transaction.without_vat
                    transaction.vat_action += " + box 9."
                end
            end
            transaction.save()
        end
        b3_totalVatDue = b1_vatDueSales + b2_vatDueAcquisitions # [3]Total VAT due (the sum of vatDueSales and vatDueAcquisitions). 
        b5_netVatDue = b4_vatReclaimedCurrPeriod - b3_totalVatDue # [5]The difference between totalVatDue and vatReclaimedCurrPeriod. 
         
        summary_data = {
            periodKey: nil, 
            vatDueSales: b1_vatDueSales, 
            vatDueAcquisitions: b2_vatDueAcquisitions,
            totalVatDue: b3_totalVatDue, 
            vatReclaimedCurrPeriod: b4_vatReclaimedCurrPeriod,
            netVatDue: b5_netVatDue,
            totalValueSalesExVAT: b6_totalValueSalesExVAT.to_i,
            totalValuePurchasesExVAT: b7_totalValuePurchasesExVAT.to_i,
            totalValueGoodsSuppliedExVAT: b8_totalValueGoodsSuppliedExVAT.to_i,
            totalAcquisitionsExVAT: b9_totalAcquisitionsExVAT.to_i,
            finalised: true
        }
        return [transactions, summary_data]
    end


end