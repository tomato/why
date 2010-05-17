class OrdersController < ApplicationController
  
  def index
    #todo security
    @customer = Customer.find(params[:customer_id])
    @orders = Order.find_candidates(@customer)
    @products = Product.find_all_by_supplier_id(@supplier)
    @product_categories = @products.group_by { |p| p.category }
  end

  def create
    begin
      Order.create_all(params)
      msg = "We updated your order"
    rescue Exception => e
      msg = "This was an error: #{ e.inspect }"
    end
    render :update do |page|
      page << "alert(\"#{msg}\")"
    end
  end

end
