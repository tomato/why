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
    @customer = Customer.find(params[:id])
    @customer.invite!
    flash[:notice] = "Invite sent to #{@customer.email}"
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

  def destroy
    @customer = Customer.find_by_id_and_supplier_id(params[:id], @supplier.id)
    @customer.destroy
    flash[:notice] = "Customer #{@customer.name} has been deleted"
    redirect_to customers_path
  end
  
  private 

  def get_rounds
    @rounds = Round.for_supplier(@supplier.id)
  end

end
