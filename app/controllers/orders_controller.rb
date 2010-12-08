class OrdersController < ApplicationController
  before_filter :check_access!
  
  def index
    @regular_orders = RegularOrder.find_or_new(@customer)
    @orders = Order.find_candidates(@customer)
    @products = Product.find_all_by_supplier_id(@customer.supplier_id)
    @product_categories = @products.group_by { |p| p.category }
    @deliveries = Delivery.next_dates(@supplier.id, 10).map{|d| [d.to_s(:short), d]}
  end

  def create
    begin
      RegularOrder.create_all(params, customer_signed_in?)
      Order.create_all(params, customer_signed_in?)
      msg = "We updated your order"
    rescue Exception => e
      msg = "This was an error: #{ e.inspect }"
    end
    render :update do |page|
      page << "why.updateResponse(\"#{escape_javascript(msg)}\")"
    end
  end

  private

  def check_access!()
    @customer = Customer.first(:conditions => {:id => params[:customer_id]})
    return if(admin_signed_in?) 
    return if(customer_signed_in? && current_customer.id == params[:customer_id].to_i) 
    return if(supplier_user_signed_in? && current_supplier_user.supplier_id == @customer.supplier_id) 

    flash[:alert] = "This is not your page!"
    redirect_to home_path
  end

end
