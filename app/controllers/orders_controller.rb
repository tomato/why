class OrdersController < ApplicationController
  before_filter :check_access!
  
  def index
    get_deliveries_and_orders
    @product_categories = Product.get_grouped(@supplier)
  end

  def past
    @past = ArchivedOrder.joins(:delivery).where(:customer_id => @customer.id).order("date desc")
  end

  def create
    begin
      RegularOrder.create_all(params, customer_signed_in?)
      Order.create_all(params, customer_signed_in?)
      @msg = "We updated your order"
    rescue Exception => e
      @msg = "This was an error: #{ e.inspect }"
    end
    get_deliveries_and_orders
    render 'deliveries' , :layout => nil
  end

  def confirm
    confirmation = Confirm.to_customer(@customer)
    confirmation.deliver
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
  
  def get_deliveries_and_orders
    @regular_orders = RegularOrder.find_or_new(@customer)
    @orders = Order.find_candidates(@customer)
    @deliveries = Delivery.next_dates_for_round(@customer.round_id, 10).map{|d| [d.to_s(:short), d]}
  end

end
