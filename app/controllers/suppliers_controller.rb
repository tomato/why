class SuppliersController < ApplicationController
  before_filter :authenticate_admin!, :except => :show

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
    authenticate_supplier!
    @supplier = Supplier.find(session[:supplier_id])
  end

end
