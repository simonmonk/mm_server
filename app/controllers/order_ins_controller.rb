require 'fileutils'

class OrderInsController < ApplicationController
  before_action :set_order_in, only: [:show, :edit, :update, :destroy, :po, :qr, :update_order_in, :delete_json]
  skip_before_filter :verify_authenticity_token 
    
  def new
    @order_in = OrderIn.new
    @order_in.supplier = Supplier.find(params['supplier_id'])
    @order_in.vat_info_collected = "N/A"
  end

  def create
    @order_in = OrderIn.new(order_in_params)
    if @order_in.save
         redirect_to :action => "edit", :id =>@order_in.id
    else
        render :new
    end
  end
    
  def qr
      render :layout => false
  end
    
  def po
      render :layout => false
  end
  
  # add a part order line to the order_in
  def add_part
    part_id = params[:part_id]
    order_in_id = params[:order_in_id]
    qty = params[:qty].to_i
    price = params[:price].to_f
    order_in = OrderIn.find(order_in_id)
    order_in.add_order_line(part_id, qty, price)
    redirect_to :action => "edit", :id => order_in_id
  end   

  def delete_part
    order_in_line_id = params[:order_in_line_id]
    order_in_id = params[:order_in_id]
    OrderInLine.find(order_in_line_id).destroy
    redirect_to :action => "edit", :id => order_in_id
  end
    
  def rx_part
    order_in_line_id = params[:order_in_line_id]
    order_in_id = params[:order_in_id]
    order_in_line = OrderInLine.find(order_in_line_id)
    qty_in = params[:qty_in].to_i
    order_in_line.qty_in += qty_in
    order_in_line.date_line_received = Date.current
    order_in_line.save
    old_qty = order_in_line.part.qty
    order_in_line.part.qty += qty_in
    order_in_line.part.save
    t = Transaction.new
    t.transaction_type = 'Stock In'
    t.description = "Part " + order_in_line.part.name + " increased in quantity from " + old_qty.to_s + " to " + order_in_line.part.qty.to_s + " as a result of a delivery for order " + order_in_id + " from " + order_in_line.order_in.supplier.name 
    t.save  
    redirect_to :action => "edit", :id => order_in_id
  end

  def save_part
    order_in_id = params[:order_in_id]
    order_in_line_id = params[:order_in_line_id]
    order_in_line = OrderInLine.find(order_in_line_id)
    order_in_line.qty = params[:qty].to_i
    order_in_line.price = params[:price].to_f
    order_in_line.save
      
    redirect_to :action => "edit", :id => order_in_id
  end      

  def import_invoice
    order_number = params['order_number']
    # go and check INVOICES share iff there's a file there move and rename it into /public/purchasing_invoices/
    share = Setting.get_setting('INVOICE_SHARE')
    root_dir = Setting.get_setting('ROOT_DIR')
    files = Dir.glob(share + "/*.pdf")
    if (files.length == 0)
      render :json => 'no file to import'
    elsif (files.length == 1)
      file = files[0]
      dest_file_name = order_number.to_s + '.pdf'
      dest = root_dir + '/public/purchasing_invoices/' + dest_file_name
      begin
        FileUtils.mv(file, dest)
      rescue Exception => boom
        return render :json => 'couldnt move file' + boom.to_s
      end
      # also send files to googledrive using gdrive
      puts "********** HERE"
      guid = Rails.application.secrets.PURCHASING_INVOICE_SHARE_GUID
      begin
        command = '/home/si/gdrive upload --parent ' + guid + ' ' + dest
        puts "******* command=" + command
        puts system(command)
      rescue Exception => boom
        return render :json => 'couldnt upload to Google Drive: ' + boom.to_s
      end
      render :json => 'ok'
    else
      render :json => 'no file or multiple files'
    end
  end

  # For file upload of invoices
  def upload
    uploaded_io = params[:file]
    share = Setting.get_setting('INVOICE_SHARE')
    filename = share + "/temp.pdf"
    File.open(filename, 'wb') do |file|
        file.write(uploaded_io.read)
    end
  end


  def update
      if @order_in.update(order_in_params)
        redirect_to :action => "edit", :id =>@order_in.id
      end   
  end

  def show
  end
    
  def edit
  end

  def index
      @order_ins = OrderIn.all.order(created_at: :desc)
  end

  # Vue page rendered from orders_in/list
  def list
  end
    
  # JSON for new UI ###################################################

  def get_orders_json
    days_string = params[:days]
    days = 90
    if (days_string)
      days = days_string.to_i
    end
    cutoff_date = Date.current - days.days
    render :json => OrderIn.where("updated_at > ?", cutoff_date).order('updated_at desc')
  end

  # add an order line to the order_in
  def add_part_json
    oil = OrderInLine.new()
    oil.part_id = params[:part_id].to_i
    oil.order_in_id = params[:order_in_id].to_i
    oil.qty = params[:qty].to_i
    oil.qty_in = params[:qty_in].to_i
    oil.price = params[:price].to_f
    oil.description = params[:description]
    oil.order_code = params[:order_code]
    oil.cost_centre_id = params[:cost_centre_id].to_i
    oil.book_keeping_category_id = params[:book_keeping_category_id]
    oil.save!

    order_in = OrderIn.find(oil.order_in_id)
    render :json => order_in
  end  


    # edit an order line to the order_in prob because qty has changed
    def edit_part_json
      oil = OrderInLine.find(params[:id].to_i)
      oil.part_id = params[:part_id].to_i
      oil.order_in_id = params[:order_in_id].to_i
      oil.qty = params[:qty].to_i
      oil.qty_in = params[:qty_in].to_i
      oil.price = params[:price].to_f
      oil.description = params[:description]
      oil.order_code = params[:order_code]
      oil.cost_centre_id = params[:cost_centre_id].to_i
      oil.book_keeping_category_id = params[:book_keeping_category_id]
      oil.save!

      order_in = OrderIn.find(oil.order_in_id)
      render :json => order_in
    end  
  
  def delete_line_item
    line_item_id = params[:line_item_id]
    OrderInLine.find(line_item_id).delete
    order_in = OrderIn.find(params[:order_in_id])
    # return the order_in without the deleted line
    render :json => order_in
  end


  def set_new_part_price_json
    part_id = params[:part_id]
    part_price = params[:part_price]
    part_currency = params[:part_currency]
    order_id = params[:order_id]
    part = Part.find(part_id)
    order = OrderIn.find(order_id)
    part.cost = part_price
    part.currency = part_currency
    part.exch_rate = Currency.find_by_name(part_currency).per_pound
    part.save
    # update the part with a new price, switch to console and print part and the new price is there. BUT reload the part edit form and the old price returns.
    # something is setting the part price as the edit form loads?
    # ANSWER: On the edit partr page, when you refresh the page, it reposts the data without warning. No problem if you close the Part page and reopen it.
    render :json => order
  end

  def delete_json
    @order_in.destroy
  end

  def rx_part_json
    order_in_line_id = params[:order_in_line_id]
    order_in_id = params[:order_in_id]
    order = OrderIn.find(order_in_id)
    order_in_line = OrderInLine.find(order_in_line_id)
    qty_in = params[:qty_in].to_i
    order_in_line.qty_in += qty_in
    order_in_line.date_line_received = params[:date_line_received]
    order_in_line.save
    old_qty = order_in_line.part.qty
    order_in_line.part.qty += qty_in
    order_in_line.part.save
    t = Transaction.new
    t.transaction_type = 'Stock In'
    t.description = "Part " + order_in_line.part.name + " increased in quantity from " + old_qty.to_s + " to " + order_in_line.part.qty.to_s + " as a result of a delivery for order " + order_in_id + " from " + order_in_line.order_in.supplier.name 
    t.save  
    render :json => order
  end

  def rx_non_part_json
    order_in_line_id = params[:order_in_line_id]
    order_in_id = params[:order_in_id]
    order = OrderIn.find(order_in_id)
    order_in_line = OrderInLine.find(order_in_line_id)
    order_in_line.qty_in = order_in_line.qty
    order_in_line.date_line_received = Date.today()
    order_in_line.save

    render :json => order
  end

  ###############################

  def update_order_in()
    if @order_in.update(order_in_params)
      render :json => @order_in
    end   
  end

  def create_order_in()
    @order_in = OrderIn.new(order_in_params)
    if @order_in.save
      render :json => @order_in
    end
  end





  def destroy
    @order_in.destroy
    redirect_to :action => "index"
  end
    
private
    # Use callbacks to share common setup or constraints between actions.
    def set_order_in
      @order_in = OrderIn.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_in_params
      params.require(:order_in).permit(:supplier_id, :placed_date, :currency, :shipping, :notes, :exch_rate, 
      :date_qr_sent, :order_number, :vat_info_collected, :quotation_received, :invoice_total_ammount, 
      :invoice_goods_ammout, :invoice_vat_ammout, :account_id, :book_keeping_category_id, :cost_centre_id,
      :description, :order_code, :part_id, :qty, :qty_in, :order_in_id, :price, :date_payment_made,
      :actually_paid_gbp, :is_service)
    end
    
end
