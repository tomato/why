class OrdersController < ApplicationController
  
  def index
    #todo security
    @customer = Customer.find(params[:customer_id])
    @orders = Order.find_candidates(@customer)
    @products = Product.find_all_by_supplier_id(@supplier)
    @product_categories = @products.group_by { |p| p.category }
  end

  def create
    Order.create_all(params)
    render :update do |page|
      page << "alert('We updated your order')"
    end
  end

end
