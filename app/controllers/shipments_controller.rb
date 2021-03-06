class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :edit, :update, :destroy, :invoice, :quote, :packing_list, :order_details]
  skip_before_filter :verify_authenticity_token 


  # GET /shipments
  # GET /shipments.json
  def index
    days_string = params[:days]
    days = 90
    if (days_string)
      days = days_string.to_i
    end
    cutoff_date = Date.current - days.days
    respond_to do |format|
        format.html { render :index }
        format.json { render :json => Shipment.where("updated_at > ?", cutoff_date).order('updated_at desc'), :level => 'concise'}
    end
  end

  # GET /shipments/1
  # GET /shipments/1.json
  def show
    render :json => @shipment
  end

  # GET /shipments/new
  def new
  end

  # GET /shipments/1/edit
  def edit
  end
    
  def invoice
      # @shipment.date_invoice_sent = Date.current
      # @shipment.save
      render :layout => false
  end

  def order_details
    render :layout => false
  end
    
  def quote
      render :layout => false
  end

  def packing_list
    render :layout => false
  end

  def product_sales
    render :layout => false
  end
    
  # json
  def update
      if @shipment.update(shipment_params)
        render :json => @shipment
      end   
  end
    
    
  def create
    @shipment = Shipment.new(shipment_params)
    @shipment.invoice_number = Shipment.find_next_invoice_number
    @shipment.date_order_received = Date.current()
    @shipment.shipping_provider = @shipment.retailer.pref_shipping_provider
    @shipment.shipping_provider_ac_no = @shipment.retailer.pref_shipping_provider_ac_no 
    @shipment.shipping_provider_shipping_type = @shipment.retailer.pref_shipping_provider_shipping_type 
    @shipment.vat_rate = Account.current_vat_rate()  
    @shipment.apply_vat_to_shipping = true
    @shipment.invoice_exch_rate = Currency.dollars_per_pound * 1.05 # stupidity tax
    if @shipment.save
        respond_to do |format|
            format.html { redirect_to :action => "edit", :id => @shipment.id }
            format.json { render :json => @shipment, :methods => [:retailer_name, :total_invoice_amount, :is_amazon, :is_new, :is_unpaid, :is_paid, :is_overdue, :shipment_products, :retailer]}
        end
    end
  end
    
# json - used to work for html too but not any more.  
def add_product
    product_id = params[:shipment_product][:product_id]
    shipment_id = params[:shipment_product][:shipment_id]
    shipment = Shipment.find(shipment_id)
    product = Product.find(product_id)
    qty = params[:shipment_product][:qty].to_i
    # if there is no product_retailer record, beacuse they haven't sold this before, create one
    results = ProductRetailer.where(retailer_id: shipment.retailer_id, product_id: product_id)
    if (results.length == 0)
        pr = ProductRetailer.new(retailer_id: shipment.retailer_id, :product_id => product_id)
        pr.save
    end
    # if there is a shipments_product record overwrite it else create a new one
    results = ShipmentProduct.where(shipment_id: shipment_id, product_id: product_id)
    if (results.length > 0)
        sp = results[0]
        sp.qty = qty
        sp.save
    else
        sp = ShipmentProduct.new(:shipment_id => shipment_id, :product_id => product_id, :qty => qty)
        sp.price = sp.invoice_price
        sp.save
    end
    render :json => sp, :methods => [:product, :line_total]
end   
    
def delete_shipment_line
    sp = ShipmentProduct.find(params[:shipment_product_id])
    if (sp)
        sp.destroy
    end
    render :json => @shipment
end       
    
def subtract_products
    message = ''
    shipment_id = params[:shipment_id]
    shipment = Shipment.find(shipment_id)
    shipment.stock_subtracted = true
    shipment.save
    count = 0
    shipment.shipment_products.each do | sp |
        if (sp.product.qty < sp.qty)
            message += 'Not enough ' + sp.product.name + " only " + sp.product.qty.to_s + " available. "
        else
            sp.product.qty = sp.product.qty - sp.qty
            sp.product.save
            count += sp.qty
        end
    end
    t = Transaction.new
    t.transaction_type = 'Shipment to ' + shipment.retailer.name
    
    t.description = "Removed " + count.to_s + " products from stock for shipment " + shipment.id.to_s + ". " + message
    t.save
    render :json => shipment
end      

def un_subtract_products
  message = ''
  shipment_id = params[:shipment_id]
  shipment = Shipment.find(shipment_id)
  shipment.stock_subtracted = false
  shipment.save
  count = 0
  shipment.shipment_products.each do | sp |
    sp.product.qty = sp.product.qty + sp.qty
    sp.product.save
    count += sp.qty
  end
  t = Transaction.new
  t.transaction_type = 'UNDID Shipment to ' + shipment.retailer.name
  
  t.description = "Replaced " + count.to_s + " products into stock for shipment " + shipment.id.to_s + ". " + message
  t.save
  render :json => shipment
end    
    
def import_shipment_uk
    shipment_code = params[:shipment_code]
    shipment_id = params[:shipment_id]
    amazon = Retailer.find_by_name('amazon.co.uk')
    shipment = Shipment.find(shipment_id)
    shipment.retailer_shipment_id = shipment_code
    shipment.save
    ShipmentProduct.where(:shipment_id => shipment_id).destroy_all
    message = ''
    begin
        client = MWS.fulfillment_inbound_shipment(
            primary_marketplace_id: Rails.application.secrets.AM_UK_PRIMARY_MARKETPLACE_ID,
            merchant_id: Rails.application.secrets.AM_UK_MERCHANT_ID,
            aws_access_key_id: Rails.application.secrets.AM_UK_ACCESS_KEY,
            aws_secret_access_key: Rails.application.secrets.AM_UK_SECRET_KEY)
        parser = client.list_inbound_shipment_items(opts = {:shipment_id => shipment_code})
        x = parser.parse

        x['ItemData']['member'].each do | product |
            sku = product['SellerSKU'] 
            qty = product['QuantityShipped']
            product = Product.lookup_sku(sku)
            sp = ShipmentProduct.new(:shipment_id => shipment_id, :product_id => product.id, :qty => qty)
            sp.save
        end
    rescue Exception => e
        message = 'Error importing shipment - check shipment id'
        puts "*********************"
        puts e
    end
    redirect_to :action => "edit", :id => shipment_id, notice: message
end   
    
def import_shipment_com
    shipment_code = params[:shipment_code]
    shipment_id = params[:shipment_id]
    amazon = Retailer.find_by_name('amazon.com')
    shipment = Shipment.find(shipment_id)
    shipment.retailer_shipment_id = shipment_code
    shipment.save
    ShipmentProduct.where(:shipment_id => shipment_id).destroy_all
    message = ''
    begin
        client = MWS.fulfillment_inbound_shipment(
            primary_marketplace_id: Rails.application.secrets.AM_US_PRIMARY_MARKETPLACE_ID,
            merchant_id: Rails.application.secrets.AM_US_MERCHANT_ID,
            aws_access_key_id: Rails.application.secrets.AM_US_ACCESS_KEY,
            aws_secret_access_key: Rails.application.secrets.AM_US_SECRET_KEY)
        parser = client.list_inbound_shipment_items(opts = {:shipment_id => shipment_code})
        x = parser.parse

        x['ItemData']['member'].each do | product |
            sku = product['SellerSKU'] 
            qty = product['QuantityShipped']
            product = Product.lookup_sku(sku)
            sp = ShipmentProduct.new(:shipment_id => shipment_id, :product_id => product.id, :qty => qty)
            sp.save
        end
    rescue Exception => e
        message = 'Error importing shipment - check shipment id'
        puts "*********************"
        puts e
    end
    redirect_to :action => "edit", :id => shipment_id, notice: message
end   
    


  # DELETE /shipments/1
  # DELETE /shipments/1.json
  def destroy
    @shipment.destroy
    respond_to do |format|
      format.html { redirect_to shipments_url, notice: 'Shipment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
    

    
    def list
        
    end

    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      @shipment = Shipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:days, :retailer_id, :dispatched, :notes, :date_order_received, :date_dispatched,:date_invoice_sent, :date_payment_reminder, 
                      :order_email_link, :po_reference, :invoice_number, :shipping_cost, :shipping_provider, :shipping_provider_ac_no, 
                      :discount, :vat_rate, :date_payment_received, :invoice_comment, :apply_vat_to_shipping, :is_cancelled, :total_invoice_collected,
                      :invoice_exch_rate, :weight_kg, :width_cm, :height_cm, :depth_cm, :tracking_info, :shipping_provider_shipping_type,
                      :account_id)
    end
end
