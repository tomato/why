class SuppliersController < ApplicationController

  def index
    @suppliers = Supplier.all
  end

  def new
    @supplier = Supplier.new
    render :action => 'edit'
  end
   
  def create
    Supplier.create(params[:supplier])
    redirect_to :action => 'index'
  end

  def show
    session[:supplier_id] = params[:id]
    redirect_to rounds_path
  end
end
