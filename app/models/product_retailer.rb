require "peddler"
require 'net/http'
require 'uri'

class ProductRetailer < ApplicationRecord
  belongs_to :product
  belongs_to :retailer
    
  def lookup_stock
    # always returns a string: 'UNKNOWN', 'IN STOCK' or 'OUT OF STOCK' or the stock qty as a number
    client = nil
    begin
      if (self.retailer.name.strip.downcase == "amazon.co.uk")
        # Amazon.co.uk - use official API
        client = MWS.fulfillment_inventory(
<<<<<<< HEAD
            primary_marketplace_id: "A1F83G8C2ARO7P",
            merchant_id: "A2NKUVTUJUJ8KU",
            aws_access_key_id: "AKIAIICZLJ3JE4FHSINQ",
            aws_secret_access_key: "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")
=======
            primary_marketplace_id: Rails.application.secrets.AM_UK_PRIMARY_MARKETPLACE_ID,
            merchant_id: Rails.application.secrets.AM_UK_MERCHANT_ID,
            aws_access_key_id: Rails.application.secrets.AM_UK_ACCESS_KEY,
            aws_secret_access_key: Rails.application.secrets.AM_UK_SECRET_KEY)
>>>>>>> 348d7164d546a6767e388f81fa199bd34729613c
        parser = client.list_inventory_supply(opts = {:seller_skus => [self.product.sku]})
        x = parser.parse
        stock = x['InventorySupplyList']['member']['TotalSupplyQuantity']
        return stock.to_s
      elsif (self.retailer.name.strip.downcase == "amazon.com")
        # Amazon.com - use official API
        client = MWS.fulfillment_inventory(
<<<<<<< HEAD
            primary_marketplace_id: "ATVPDKIKX0DER",
            merchant_id: "A14D2WDBSBCN3L",
            aws_access_key_id: "AKIAISNBGVKB2MW7DNJQ",
            aws_secret_access_key: "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")
=======
            primary_marketplace_id: Rails.application.secrets.AM_US_PRIMARY_MARKETPLACE_ID,
            merchant_id: Rails.application.secrets.AM_US_MERCHANT_ID,
            aws_access_key_id: Rails.application.secrets.AM_US_ACCESS_KEY,
            aws_secret_access_key: Rails.application.secrets.AM_US_SECRET_KEY)
>>>>>>> 348d7164d546a6767e388f81fa199bd34729613c
        parser = client.list_inventory_supply(opts = {:seller_skus => [self.product.sku]})
        x = parser.parse
        stock = x['InventorySupplyList']['member']['TotalSupplyQuantity']
        # some amazon.com products have a SKU with FBA on the end of the normal SKU
        if (stock.to_i == 0)
            parser = client.list_inventory_supply(opts = {:seller_skus => [self.product.sku + "FBA"]})
            x = parser.parse
            stock = x['InventorySupplyList']['member']['TotalSupplyQuantity']
        end
        return stock.to_s
      else
        # Others - use web scrapingl
        pageContent = Net::HTTP.get(URI.parse(url))
        regex = Regexp.new(self.retailer.regex_qty)
        resultSet = regex.match(pageContent)
        if (resultSet && resultSet.length == 1)
            numRegex = /[0-9]+/
            resultSet = numRegex.match(resultSet[0])
            return resultSet[0]
        else
            # change this to check for OOS and In Stock messages without qty
            return "UNKNOWN"
        end
      end
    rescue Exception => e
        puts "I'm making errors - comment me out when you need to - request error to MWS"
        puts e
    end
    return 'UNKNOWN'
  end
    
end
