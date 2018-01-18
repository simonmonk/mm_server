class OrderInsController < ApplicationController
      before_action :set_order_in, only: [:show, :edit, :update, :destroy]
    
  def new
    @order_in = OrderIn.new
    @order_in.supplier = Supplier.first
    @order_in.save
    redirect_to :action => "edit", :id =>@order_in.id
  end

  def create
    @order_in = OrderIn.new(order_in_params)
    if @order_in.save
         redirect_to :action => "edit", :id =>@order_in.id
    end
  end
    
  def add_part
    part_id = params[:part_id]
    order_in_id = params[:order_in_id]
    qty = params[:qty].to_i
    price = params[:price].to_f
    part = Part.find(part_id)
    old_price = part.cost
    part.cost = price
    part.save
    order_line = nil
    results = OrderInLine.where(order_in_id: order_in_id, part_id: part_id)
    if (results.length > 0)
        order_line = results[0]
        order_line.qty = qty 
        order_line.qty_in = 0
        order_line.price = price
        order_line.save
    else
        order_line = OrderInLine.new(:order_in_id => order_in_id, :part_id => part_id, :qty => qty, :qty_in => 0, :price => price)
        order_line.save
    end
    if (old_price.round(2) != price.round(2)) 
        t = Transaction.new
        t.transaction_type = 'Part cost change'
        t.description = "Part " + part.name + " changed price from " + old_price.to_s + " to " + price.to_s +
          " as a result of order (goods in) from " + order_line.order_in.supplier.name 
        t.save
    end
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
      @order_ins = OrderIn.all
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
