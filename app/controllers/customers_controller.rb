class CustomersController < ApplicationController
  
  def index
    @customers = Customer.find_all_by_supplier_id(session[:supplier_id])
  end

  def new
    @customer = Customer.new
    @rounds = Round.for_supplier(session[:supplier_id])
  end

  def create
    @customer = Customer.new(params[:customer])
    @customer.password = 'fdjaHjk9099kjflkjl'
    @customer.supplier_id = session[:supplier_id]
    @customer.invite!
    redirect_to customers_path
  end
end
