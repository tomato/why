class OrdersController < ApplicationController
  
  def index
    #todo security
    @customer = Customer.find(params[:customer_id])
    @regular_orders = RegularOrder.find_or_new(@customer)
    @orders = Order.find_candidates(@customer)
    @products = Product.find_all_by_supplier_id(@customer.supplier_id)
    @product_categories = @products.group_by { |p| p.category }
  end

  def create
    begin
      RegularOrder.create_all(params)
      Order.create_all(params)
      msg = "We updated your order"
    rescue Exception => e
      msg = "This was an error: #{ e.inspect }"
    end
    render :update do |page|
      page << "why.updateResponse(\"#{escape_javascript(msg)}\")"
    end
  end

end
