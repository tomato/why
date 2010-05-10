class OrdersController < ApplicationController
  
  def index
    #todo security
    @customer = Customer.find(params[:customer_id])
    @deliveries = Delivery.find_all_by_round_id(@customer.round_id)
    @products = Product.find_all_by_supplier_id(@supplier)
    @product_categories = @products.group_by { |p| p.category }
  end

  def create
    render :update do |page|
      page << "alert('We updated your order')"
    end
  end

end
