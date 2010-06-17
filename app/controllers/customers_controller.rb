class CustomersController < ApplicationController
  before_filter :authenticate_supplier!
  
  def index
    @customers = Customer.find_all_by_supplier_id(@supplier.id)
  end
  
  def edit
    @customer = Customer.find(params[:id])
    @rounds = Round.for_supplier(@supplier.id)
  end

  def new
    @customer = Customer.new
    @rounds = Round.for_supplier(@supplier.id)
    render :action => 'edit'
  end

  def create
    @customer = Customer.new(params[:customer])
    @customer.password = 'fdjaHjk9099kjflkjl'
    @customer.supplier_id = @supplier.id
    @customer.invite!
    redirect_to customers_path
  end


end
