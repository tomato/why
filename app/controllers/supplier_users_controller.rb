class SupplierUsersController < ApplicationController
  before_filter :authenticate_supplier!

  def index 
    @supplier_users = SupplierUser.find_all_by_supplier_id(@supplier.id)
  end

  def new 
    @supplier_user = SupplierUser.new
  end

  def create
    @supplier_user = SupplierUser.new(params[:supplier_user])
    @supplier_user.supplier_id = @supplier.id
    @supplier_user.password = 'flk3l343kjl23'
    @supplier_user.invite!
    redirect_to supplier_path(@supplier)
  end

  def destroy
    @supplier_user = SupplierUser.find(params[:id])
    @supplier_user.destroy
    redirect_to :action => :index
  end

end
