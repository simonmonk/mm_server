require 'net/http'
require 'uri'
require 'json'

class Currency < ApplicationRecord
    
  def Currency.gbp()
    return Currency.find_by_name('GBP')
  end

  def Currency.usd()
    return Currency.find_by_name('USD')
  end

  def Currency.eur()
    return Currency.find_by_name('EUR')
  end

  def Currency.set_usd_rate
      key = Rails.application.secrets.CURRENCY_LAYER_KEY
      url = "http://apilayer.net/api/live?access_key=" + key + "&currencies=GBP"
      page_content = Net::HTTP.get(URI.parse(url))
      result = JSON.parse(page_content)
      usd_to_gbp = 1/(result["quotes"]["USDGBP"].to_f)
      dollar = Currency.usd()
      dollar.per_pound = usd_to_gbp
      dollar.save
  end
    
  def Currency.dollars_per_pound
      dollar = Currency.usd()
      return dollar.per_pound
  end
    
  def Currency.dollar_rate_set_date
      dollar = Currency.usd()
      return dollar.updated_at
  end
    
end