class Sale < ApplicationRecord
    belongs_to :product
    belongs_to :retailer
    
    def Sale.current_week_of_epoch()
        return (Time.now().to_i / 604800).to_i
    end

    def Sale.week_of_epoch(date)
        return (date.to_i / 604800).to_i
    end

    def Sale.date_for_week_of_epoch(woe)
        return Time.at(woe * 604800)
    end
    
    def Sale.date_for_week_of_epoch_formatted(woe)
        return Sale.date_for_week_of_epoch(woe).strftime("%d/%m/%Y")
    end
        
    
    def Sale.week_labels(num_weeks)
        this_week = Sale.current_week_of_epoch()
        result = "["
        (this_week - num_weeks + 1).upto(this_week) do |woe| 
            result += '"' + Sale.date_for_week_of_epoch_formatted(woe) + '",'
        end
        result += "]"
        return result
    end
    
    def Sale.chart_data_count(num_weeks, amazon_id, product_id)
        product = Product.find(product_id)
        this_week = Sale.current_week_of_epoch()
        result = "{ label: '" + product.name + "', data: ["
        (this_week - num_weeks + 1).upto(this_week) do |woe| 
            sale = Sale.where(:retailer_id => amazon_id, :product_id => product_id, :week => woe).first
            count = 0
            if (sale)
                count = sale.count
            end
            result += count.to_s + ","
        end
        result += "],"
        return result
#        return "label: 'Total Sales Amazon.co.uk', data: [12, 19, 3, 5],"
    end
    
    def Sale.chart_data_count_all(num_weeks, amazon_id)
        this_week = Sale.current_week_of_epoch()
        result = "{ label: 'ALL PRODUCTS', data: ["
        (this_week - num_weeks + 1).upto(this_week) do |woe| 
            sales = Sale.where(:retailer_id => amazon_id, :week => woe)
            count = 0
            sales.each do | sale |
                count += sale.count
            end
            result += count.to_s + ","
        end
        result += "],"
        return result
#        return "label: 'Total Sales Amazon.co.uk', data: [12, 19, 3, 5],"
    end
    
    def Sale.chart_data_value(num_weeks, amazon_id, product_id)
        product = Product.find(product_id)
        this_week = Sale.current_week_of_epoch()
        result = "{ label: '" + product.name + "', data: ["
        (this_week - num_weeks + 1).upto(this_week) do |woe| 
            sale = Sale.where(:retailer_id => amazon_id, :product_id => product_id, :week => woe).first
            value = 0
            if (sale)
                value = sale.value
            end
            result += value.to_s + ","
        end
        result += "],"
        return result
#        return "label: 'Total Sales Amazon.co.uk', data: [12, 19, 3, 5],"
    end
    
    def Sale.chart_data_value_all(num_weeks, amazon_id)
        this_week = Sale.current_week_of_epoch()
        result = "{ label: 'ALL PRODUCTS', data: ["
        (this_week - num_weeks + 1).upto(this_week) do |woe| 
            sales = Sale.where(:retailer_id => amazon_id, :week => woe)
            value = 0
            sales.each do | sale |
                value += sale.value
            end
            result += value.to_s + ","
        end
        result += "],"
        return result
#        return "label: 'Total Sales Amazon.co.uk', data: [12, 19, 3, 5],"
    end    
    
    
end
