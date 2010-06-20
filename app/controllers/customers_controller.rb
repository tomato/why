class CustomersController < ApplicationController
  before_filter :authenticate_supplier!, :get_rounds
  
  def index
    @customers = Customer.find_all_by_supplier_id(@supplier.id)
  end
  
  def edit
    @customer = Customer.find(params[:id])
    @rounds = Round.for_supplier(@supplier.id)
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(params[:customer])
    @customer.password = Customer::DEFAULT_PASSWORD
    @customer.supplier_id = @supplier.id
    if(@customer.save)
      redirect_to customers_path
    else
      render :action => :new
    end
  end

  def invite
    Customer.find(params[:id]).invite!
    redirect_to customers_path
  end

  def resend
    Customer.find(params[:id]).invite!
    redirect_to customers_path
  end

  def update
    @customer = Customer.find(params[:id])
    if(@customer.update_attributes(params[:customer]))
       redirect_to customers_path
    else
      render :action => :edit
    end

  end
  
  private 

  def get_rounds
    @rounds = Round.for_supplier(@supplier.id)
  end

end
