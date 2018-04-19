class OrderInsController < ApplicationController
  before_action :set_order_in, only: [:show, :edit, :update, :destroy, :po, :qr]
    
  def new
    @order_in = OrderIn.new
    @order_in.supplier = Supplier.find(params['supplier_id'])
    @order_in.placed_date = Date.current()
    @order_in.save
    redirect_to :action => "edit", :id =>@order_in.id
  end

  def create
    @order_in = OrderIn.new(order_in_params)
    if @order_in.save
         redirect_to :action => "edit", :id =>@order_in.id
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
      params.require(:order_in).permit(:supplier_id, :placed_date, :currency, :shipping, :notes)
    end
    
end
