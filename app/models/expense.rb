class Expense < ApplicationRecord

    belongs_to :account, optional: true
    belongs_to :user, optional: true

    def transaction_type()
        return 'EXPENSE'
    end

    def expense_number()
        return "EXP-" + id.to_s
    end

    def name()
        'EXP-' + id.to_s
    end

    def accounting_date()
        return reimbursed_date
    end

    def vat_action()
        return ""
    end

    def is_income()
        return false
    end

    def direction()
        return 'MONEY_OUT'
    end

    # TBD
    def boxes()
        return []
    end

    # May be redundant
    def is_vatable()
        return false
    end

    def tax_region()
        return 'UK'
    end

    def accounts()
        return account.name
    end

    def account_ids()
        return [account_id]
    end

    def transaction_summary()
        return 'Expense for ' + user.name
    end

    def has_proof_uploaded()
        root_dir = Setting.get_setting('ROOT_DIR')
        file = Dir.glob(root_dir + '/public/expense_receipts/' + name + '.pdf')
        return (file.length == 1)
    end

    def as_json(options={})
        super(:methods => [:accounting_date, :transaction_type, :vat_action, :is_income, :is_vatable,
                        :accounts, :account_ids, :transaction_summary, :direction, :name, :has_proof_uploaded,
                        :expense_number ])
    end  

end
