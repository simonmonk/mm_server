require "peddler"

def getClient()
    client = MWS.orders(
  primary_marketplace_id: "A1F83G8C2ARO7P",
  merchant_id: "A2NKUVTUJUJ8KU",
  aws_access_key_id: "AKIAIICZLJ3JE4FHSINQ",
  aws_secret_access_key: "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"
        )
    return client
end

def getStatus()
    client = getClient()
    parser = client.get_service_status
    parser.parse # will return a Hash object
    return parser.dig('Status') # delegates to Hash#dig for convenience
end

def getOrderTotal(created_after, created_before)
    puts created_after
    client = getClient()
    parser = client.list_orders(opts = {:created_after => created_after, :created_before => created_before})
    x = parser.parse
    n = 0
    total = 0

    x['Orders']['Order'].each do |order|
        if (order['OrderTotal'])
            total += order['OrderTotal']['Amount'].to_i
            n += 1
        end
    end
    return total
end

def getTotals12Month()
    totals = []
    today = Time.now
    y = today.year
    m = today.month
    12.times do
        sleep(2)
        m -= 1
        if (m < 1)
            m = 12
            y -= 1
        end
        d0 = Time.new(y, m, 1)
        d1 = Time.new(y, m, Date.new(y, m, -1).day)
        t = getOrderTotal(d0.strftime("%Y-%m-%d"), d1.strftime("%Y-%m-%d"))
        totals.push(t)
    end
    return totals
end

p getStatus()
p getTotals12Month()

#p x['InventorySupplyList']['member']['TotalSupplyQuantity']
# 