class ShipmentsController < ApplicationController
  before_action :set_shipment, only: [:show, :edit, :update, :destroy, :invoice]
  skip_before_filter :verify_authenticity_token 

  # GET /shipments
  # GET /shipments.json
  def index
    @shipments = Shipment.all
  end

  # GET /shipments/1
  # GET /shipments/1.json
  def show
  end

  # GET /shipments/new
  def new
    @shipment = Shipment.new
    @shipment.retailer = Retailer.find(params['retailer_id'])
    @shipment.date_order_received = Date.current()
    @shipment.shipping_provider = @shipment.retailer.pref_shipping_provider
    @shipment.shipping_provider_ac_no = @shipment.retailer.pref_shipping_provider_ac_no
    @shipment.invoice_number = Shipment.find_next_invoice_number()  
    @shipment.vat_rate = 20  
  end

  # GET /shipments/1/edit
  def edit
  end
    
  def invoice
      render :layout => false
  end
    
    
  def update
      if @shipment.update(shipment_params)
        redirect_to :action => "edit", :id =>@shipment.id
      end   
  end
    
    
  def create
    @shipment = Shipment.new(shipment_params)
    if @shipment.save
         redirect_to :action => "edit", :id =>@shipment.id
    else
        render :new
    end
  end
    
def add_product
    product_id = params[:product_id]
    shipment_id = params[:shipment_id]
    qty = params[:qty].to_i
    results = ShipmentProduct.where(shipment_id: shipment_id, product_id: product_id)
    if (results.length > 0)
        pp = results[0]
        pp.qty = qty
        pp.save
    else
        pp = ShipmentProduct.new(:shipment_id => shipment_id, :product_id => product_id, :qty => qty)
        pp.save
    end
    redirect_to :action => "edit", :id => shipment_id
end   
    
    
def delete_shipment_line
    sp = ShipmentProduct.find(params[:shipment_product_id])
    if (sp)
        sp.destroy
    end
    redirect_to :action => "edit", :id => sp.shipment_id
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
    redirect_to :action => "edit", :id => shipment_id, notice: message
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shipment
      @shipment = Shipment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shipment_params
      params.require(:shipment).permit(:retailer_id, :dispatched, :notes, :date_order_received, :date_dispatched,:date_invoice_sent, :date_payment_reminder, :order_email_link, :po_reference, :invoice_number, :shipping_cost, :shipping_provider, :shipping_provider_ac_no, :discount, :vat_rate, :date_payment_received)
    end
end
