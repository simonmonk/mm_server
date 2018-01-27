require "peddler"

class ApisController < ApplicationController
  skip_before_filter :verify_authenticity_token 

def show
  end

def current_week_of_epoch()
    return (Time.now().to_i / 604800).to_i
end

def date_for_week_of_epoch(woe)
    return Time.at(woe * 604800)
end
    
def import_order_item(item, woe, amazon)
    # create a product_retailer_sale for the week in question (or find and add to exisitng record)
    sku = item['SellerSKU']
    qty = item['QuantityOrdered'].to_i
    value = item['ItemPrice']['Amount'].to_f

    product = Product.lookup_sku(sku)
    if (! product)
        puts "NO PRODUCT"
        return
    end
    sale = Sale.where(:retailer_id => amazon.id, :product_id => product.id, :week => woe).first
    puts "sale=" + sale.to_s
    
    if (!sale)
        puts "No sale - creating one"
        sale = Sale.new
        sale.retailer_id = amazon.id
        sale.product_id = product.id
        sale.week = woe
        sale.count = 0
        sale.value = 0.0
        puts "made new"
    end
    
    sale.count = sale.count + qty
    sale.value = sale.value + value
    sale.save

end


def import_orders_amazon_uk()
    woe = params['woe'].to_i
    import_orders_amazon_uk_week(woe)
end
    
def import_orders_amazon_uk_week(woe)
    created_after = date_for_week_of_epoch(woe - 1)
    created_before = date_for_week_of_epoch(woe)
    puts created_after
    puts created_before
    
    # clear exisitng sales for this retailer and week prior to filling it up again specific to product
    amazon = Retailer.find_by_name('amazon.co.uk')
    Sale.delete_all(["week = ? AND retailer_id = ?", woe, amazon.id])
    
    client = MWS.orders(
            primary_marketplace_id: Rails.application.secrets.AM_UK_PRIMARY_MARKETPLACE_ID,
            merchant_id: Rails.application.secrets.AM_UK_MERCHANT_ID,
            aws_access_key_id: Rails.application.secrets.AM_UK_ACCESS_KEY,
            aws_secret_access_key: Rails.application.secrets.AM_UK_SECRET_KEY)
    
    parser = client.list_orders(opts = {:created_after => created_after, :created_before => created_before})
    x = parser.parse
    x['Orders']['Order'].each do |order|
        if (order['OrderTotal'])
            sleep(3) # avoid throttling
            p = client.list_order_items(order['AmazonOrderId'])
            order_items = p.parse()['OrderItems']['OrderItem']
                if (order_items.class == Array)
                    n = Notification.new
                    n.dismissed = false
                    n.priority = 3
                    n.message = "UNUSUAL ORDER (amazon.co.uk): Order number: " + 
                        order['AmazonOrderId'] + ". On " + order['PurchaseDate'] + " " + 
                        order['BuyerName'] + " ordered " + order['NumberOfItemsShipped'].to_s +
                        " items totalling " + order['OrderTotal']['CurrencyCode'] + " " +
                        order['OrderTotal']['Amount']
                    n.save
                    order_items.each do |order_item|
                        self.import_order_item(order_item, woe, amazon)
                    end
                elsif (order_items.class == Hash)
                    self.import_order_item(order_items, woe, amazon)
                end
        end
    end
end
    
def import_orders_amazon_com()
    woe = params['woe'].to_i
    import_orders_amazon_com_week(woe)
end
    
def import_orders_amazon_com_week(woe)
    created_after = date_for_week_of_epoch(woe - 1)
    created_before = date_for_week_of_epoch(woe)
    puts created_after
    puts created_before
    
    # clear exisitng sales for this retailer and week prior to filling it up again specific to product
    amazon = Retailer.find_by_name('amazon.com')
    Sale.delete_all(["week = ? AND retailer_id = ?", woe, amazon.id])
    
    client = MWS.orders(
            primary_marketplace_id: Rails.application.secrets.AM_US_PRIMARY_MARKETPLACE_ID,
            merchant_id: Rails.application.secrets.AM_US_MERCHANT_ID,
            aws_access_key_id: Rails.application.secrets.AM_US_ACCESS_KEY,
            aws_secret_access_key: Rails.application.secrets.AM_US_SECRET_KEY)

    parser = client.list_orders(opts = {:created_after => created_after, :created_before => created_before})
    x = parser.parse
    x['Orders']['Order'].each do |order|
        if (order['OrderTotal'])
            sleep(3) # avoid throttling
            p = client.list_order_items(order['AmazonOrderId'])
            order_items = p.parse()['OrderItems']['OrderItem']
                if (order_items.class == Array)
                  begin    
                    n = Notification.new
                    n.dismissed = false
                    n.priority = 3
                    n.message = "UNUSUAL ORDER (amazon.com): Order number: " + 
                        order['AmazonOrderId'] + ". On " + order['PurchaseDate'] + " " + 
                        order['BuyerName'] + " ordered " + order['NumberOfItemsShipped'].to_s +
                        " items totalling " + order['OrderTotal']['CurrencyCode'] + " " +
                        order['OrderTotal']['Amount']
                    n.save
                    order_items.each do |order_item|
                        self.import_order_item(order_item, woe, amazon)
                    end
                  rescue Exception => e
                     puts "Missing data constructing notification"
                     puts e
                  end
                elsif (order_items.class == Hash)
                    self.import_order_item(order_items, woe, amazon)
                end
        end
    end
end    
    
# http://localhost:3000/apis/import_all_orders   
def import_all_orders()
    2467.downto(2459) do |woe| 
        import_orders_amazon_com_week(woe)
    end
end
    
#{"OrderItems"=>
#        {"OrderItem"=>[     ****** if only 1 item there is no array
#            {"QuantityOrdered"=>"1", "SellerSKU"=>"SKU0002", 
#                "ItemPrice"=>{"CurrencyCode"=>"GBP", "Amount"=>"15.00"}
#                }, 
#            {"QuantityOrdered"=>"1", "SellerSKU"=>"SKU00051", 
#                "ItemPrice"=>{"CurrencyCode"=>"GBP", "Amount"=>"11.50"}
#                }
#            ]},
#    "AmazonOrderId"=>"206-3629282-9580326"}    


# http://localhost:3000/apis/check_stock_levels     
def check_stock_levels()
    ProductRetailer.all.each do |pr|
        stock = pr.lookup_stock
        if (stock == "0")
            n = Notification.new
            n.dismissed = false
            n.priority = 1
            n.message = "OUT OF STOCK! " + pr.retailer.name + " is out of stock for product " +
                pr.product.name 
            n.save
        elsif (stock.to_i > 0 && stock.to_i < pr.weekly_sales_avg.to_i * 2)
            n = Notification.new
            n.dismissed = false
            n.priority = 2
            n.message = "LOW STOCK! Less than 2 weeks stock left at <b>" + pr.retailer.name + 
                "</b> for product <b>" + pr.product.name + "</b> only " + stock + 
                " remaining and average sales of " + pr.weekly_sales_avg.to_s + " sales per week."
            n.save
        end
    end
end
    
# http://localhost:3000/apis/nightly    
def nightly()
   this_week = Sale.current_week_of_epoch
   Notification.delete_all 
   import_orders_amazon_com_week(this_week)
   import_orders_amazon_uk_week(this_week)
   check_stock_levels()
end
    
end
