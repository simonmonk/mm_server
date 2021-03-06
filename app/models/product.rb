require 'fileutils'
require "open-uri"
require 'ImageResize'

class Product < ApplicationRecord
    has_many :product_parts
    has_many :product_assemblies
    has_many :product_retailers
    has_many :shipment_products
    
    belongs_to :product_category
    belongs_to :hs_code
    
    validates :name, presence: true
    validates :qty, numericality: { greater_than_or_equal_to: 0 }
    validates :stock_warning_level, numericality: { greater_than_or_equal_to: 0 }
    validates :sku, presence: true
    validates :labour, presence: true
    
    
    has_attached_file :barcode, styles: { medium: "230x154>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
    validates_attachment_content_type :barcode, content_type: /\Aimage\/.*\z/
    
    # return all the Active products
    # sorted alphabeticaly for use in lists
    def Product.active_products
        Product.all.where(active: true).order(name: :asc)
    end
    
    # used as a local cache to indicate that the product is already sold by a retailer
    attr_accessor :local_scope
    
    # calculate the production cost by adding up the costs of all the parts and assemblies
    # finally add in the labor cost for the product. Note that assemblies will have their own
    # labour cost.
    def production_cost
        total = 0
        self.product_parts.each do |pp|
          if (pp.part)
            total += pp.part.purchase_cost * pp.qty
          else
            # No part on a pp means the pp should be garbage collected
            pp.delete()
          end
        end
        self.product_assemblies.each do |pp|
            total += pp.assembly.production_cost * pp.qty
        end
        if (self.labour)
            total += self.labour
        end
        return total
    end

    def calculated_labour_cost
        if (not build_time_mins || build_time_mins == 0)
            return 0
        else
            hourly_rate = Setting.get_setting('HOURLY_RATE')
            pounds_per_min = hourly_rate.to_f / 60.0
            return (pounds_per_min * build_time_mins).round(2)
        end
    end


    ##### start of methods for website generation

    def webpage_name
        return product_url.split('/').last
    end

    def carousel_images
        images = []
        for i in 0..4 do
            im = self.send('carousel_' + i.to_s)
            if (im and im.length > 2)
                images.append(im)
            end
        end
        return images
    end

    def website_product_retailers
        rets = []
        self.product_retailers.each do | product_retailer |
            retailer = product_retailer.retailer
            if (retailer.include_in_website == true and retailer.active and not retailer.is_retail)
                rets.append(product_retailer)
            end
        end
        return rets
    end

    # Move all old wordpress-style images to /images and redirect the image locations in the database too
    # it also creates thunbnails to give faster website loading for generated pages
    # Run this on the live database, so that the links are updated.
    def Product.migrate_all_images
        Product.all.each do | product |
            if (product.active)
                puts "Moving Images for product: " + product.name
                product.move_images_to_website()
            end
        end
        return 0
    end

    # This needs fixing to cope with image urls that have spaces in
    # assuming it can get the original file, it should replace spaces with underscores in the target file
    def move_images_to_website
        image_sources = [:product_photo_uri, :carousel_0, :carousel_1, :carousel_2, :carousel_3, :carousel_4]
        image_sources.each do | im_src |
            im_url = self[im_src]
            if (im_url and im_url.length > 0)
                move_image(im_url, im_src)
            end
        end
    end

    def move_image(im_url, image_field)
        extension = im_url.split('.').last
        # filename may have crap like this on the end: ?fit=960%2C960
        # but it doesn't matter beacause the page loads anyway
        if (im_url.split(' ').length > 1)
            # could be a bit smarter here - but no urls with spaces found in db.
            puts "***** url with spaces: " + im_url
            return
        end
        filename_org = im_url.split('/').last
        temp_dir = Setting.get_setting('TEMP_DIR')
        filename_thumb = temp_dir + 'thumb.' + extension
        begin
            File.open(filename_org, 'wb') do | fo |
                fo.write(open(im_url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE).read)
            end
        rescue
            puts "**** Original image file missing: " + im_url
            return
        end
        Image.resize(filename_org, filename_thumb, 200, 2000)
        # put the two images onto the server
        org_file_path = webpage_name() + "/" + filename_org
        thumb_file_path = webpage_name() + "/thumb_" + filename_org
        rcp(filename_org, "images/" + org_file_path)
        rcp(filename_thumb, "images/" + thumb_file_path)
        # only update url if the image can be read withjout error.
        new_url = "https://monkmakes.com/images/" + org_file_path
        puts "Moving image from: " + im_url + " to: " + new_url
        begin
            u = open(new_url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) 
            if (u.status[1] == 'OK')
                puts "Saving NEW URL: " + new_url + " for product: " + self.name
                update_attribute(image_field, new_url)
            end
        rescue
            puts "Error opening Image URL: " + new_url
        end
    end

    def rcp(local_file, remote_file)
        # cert location for server vs local is different
        scp_upload_command_1 = "ssh -i /home/si/MMServer2020.pem ec2-user@3.11.90.43 'mkdir /data/www/images/" + webpage_name() + "'"
        scp_upload_command_2 = "scp -i /home/si/MMServer2020.pem " + local_file + " ec2-user@3.11.90.43:/data/www/" + remote_file
        
        puts scp_upload_command_1
        system(scp_upload_command_1)
        puts scp_upload_command_2
        system(scp_upload_command_2)
    end

    def product_photo_thumbnail_url()
        path_file = File.split(self.product_photo_uri)
        path = path_file[0]
        file = "thumb_" + path_file[1]
        return File.join(path, file)
    end


    ##### end of methods for website generation
    
    def units_and_value_shipped(start_date, end_date)
        #shipments = Shipment.where("date_order_received >= :start_date AND date_order_received < :end_date", {start_date: start_date, end_date: end_date})
        units_sold = 0
        value_sold = 0
        profit_total = 0
        self.shipment_products.each do | sp |
            if (sp.shipment)
                sp_date = sp.shipment.date_order_received
                if (sp_date and sp_date > start_date and sp_date <= end_date)
                    units_sold += sp.qty
                    value_sold += sp.price * sp.qty
                    profit_total += sp.qty * sp.product.profit
                end
            end
        end
        return [units_sold, value_sold, profit_total]
    end
    
    def profit
        if (self.wholesale_price_catalog)
            return [self.wholesale_price_catalog - self.production_cost, 0].max
        else
            return 0
        end
    end

    # suggested wholesale price add 40% to manufacturing cost
    def suggested_wholesale
        return self.production_cost * 1.4
    end
    

    # suggested retail 40% gross margin for retailer on wholesale price
    def suggested_retail
    	if (! self.wholesale_price_catalog)
    		return 0
    	end
        return self.wholesale_price_catalog / (1 - 0.4) # 40% margin
    end
    

    # calculate the number of products that can be made constrained by
    # the numbers of parts and assemplies available
    def possible_makes
        n_max = 100000000000000
        n = n_max
        self.product_parts.each do |pp|
            if (pp.qty > 0.0)
                stock_to_needed = (pp.part.qty / pp.qty).to_i()
                if (stock_to_needed < n)
                    n = stock_to_needed
                end
            end
        end
        self.product_assemblies.each do |pa|
            stock_to_needed = (pa.assembly.qty / pa.qty).to_i()
            if (stock_to_needed < n)
                n = stock_to_needed
            end
        end
        if (n == n_max)
            return 0
        else
            return n
        end
    end

    # some products are just bagged boards, and ready to be included in a kit or sold as products in their own right
    def is_single_assembly_product
        return (product_parts.length == 0 and product_assemblies.length == 1)
    end

    def stock_level_inc_ready_made_assemblies
        if (is_single_assembly_product)
            ass = product_assemblies[0].assembly
            return qty + ass.qty
        else
            return qty
        end
    end

    def units_sold_per_month
        total_units = 0
        first_sale_date = Date.today
        last_sale_date = Date.new
        self.shipment_products.each do | sp |
            if (sp.shipment and sp.shipment.date_order_received and sp.qty)
                if (sp.shipment.date_order_received < first_sale_date)
                    first_sale_date = sp.shipment.date_order_received
                end
                if (sp.shipment and sp.shipment.date_order_received > last_sale_date)
                    last_sale_date = sp.shipment.date_order_received
                end
                total_units += sp.qty
            end
        end
        days = last_sale_date - first_sale_date
        months = days.to_f / 30.0
        units_per_month = (total_units / months).round(2)
        months_worth = (stock_level_inc_ready_made_assemblies / units_per_month).round(2)
        return {:total_units => total_units, 
                :first_sale_date => first_sale_date,
                :units_per_month => units_per_month,
                :months_worth => months_worth
            }
    end

    # find a prpduct by SKU with some fancy processing rules for
    # Amazon skus needed for integration with Amazon API
    def Product.lookup_sku(sku)
        product = Product.find_by_sku(sku)
        if (product)
            return product
        elsif (sku.downcase.ends_with?('fba'))
            # amazon /.com may have FBA on the end of the SKU, so chop it off
            short_sku = sku[0..-4]
            product = Product.find_by_sku(short_sku)
            if (product)
                return product
            end
        end
        return nil
    end
    
    def find_next_sku()
        skus = []
        Product.all.each do | p |
            if (p.sku.start_with?("SKU"))
                skus.append(p.sku[3..-1].to_i)
            end
        end
        n = skus.sort.last+1
        return "SKU" + n.to_s.rjust(4, "0")
    end

    # Total value of all products in the system
    def Product.total_value
        total = 0
        Product.all.each do |prod|
            total += (prod.production_cost * prod.qty)
        end
        return total
    end

    # deduct quatities of all the parts and assemblies used for n of this product.
    def deduct_stock(n, n_fails = 0)
        self.product_parts.each do |pp|
            pp.part.qty = pp.part.qty - pp.qty * n
            pp.part.save
        end
        self.product_assemblies.each do |pp|
            pp.assembly.qty = pp.assembly.qty - pp.qty * n
            pp.assembly.save
        end
        self.qty = self.qty + n - n_fails
        self.save
        t = Transaction.new
        t.transaction_type = 'Deduct Stock for Product'
        t.description = "Removed parts and assemblies from stock to make " + n.to_s + " new " + self.name
        t.save
    end
    
    def Product.last_barcode
        bc = 0
        Product.all.each do |prod|
            if (prod.barcode_value.to_i > bc)
                bc = prod.barcode_value.to_i
            end
        end 
        return bc
    end

    # change prices so that if they have catalog prices, the invoice prices are set to be the same.
    def bring_prices_inline_with_catalog()
        if (self.active and self.include_in_catalog)
            if (self.wholesale_price_catalog and self.wholesale_price_catalog > 0 and self.wholesale_price_catalog != self.wholesale_price)
                old_wholesale_price = self.wholesale_price
                self.wholesale_price = self.wholesale_price_catalog
                self.save()
                t = Transaction.new
                t.transaction_type = 'Update Product Pricing'
                t.description = "Changed Wholesale Price of " + self.name + " from: " + old_wholesale_price.to_s + " to " + self.wholesale_price.to_s
                puts t.description
                t.save
            end
            if (self.retail_price_catalog and self.retail_price_catalog > 0 and self.retail_price_catalog != self.retail_price)
                old_retail_price = self.retail_price
                self.retail_price = self.retail_price_catalog
                self.save()
                t = Transaction.new
                t.transaction_type = 'Update Product Pricing'
                t.description = "Changed Retail Price of " + self.name + " from: " + old_retail_price.to_s + " to " + self.retail_price.to_s
                puts t.description
                t.save
            end
        end
    end

    
    def Product.bring_all_prices_inline_with_catalog()
        Product.all.each do | product |
            product.bring_prices_inline_with_catalog
        end
    end
    

    def as_json(options={})
        puts "prod " + options.to_s
        if (options[:level] == 'with_stats')
            return super(:methods => [:possible_makes, :stock_level_inc_ready_made_assemblies, :units_sold_per_month])
        else
            return super()
        end  
    end
end
