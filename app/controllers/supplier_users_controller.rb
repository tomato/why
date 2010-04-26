class SupplierUsersController < ApplicationController
  def new 
    @supplier_user = SupplierUser.new
  end

  def create
    @supplier_user = SupplierUser.new(params[:supplier_user])
    @supplier_user.supplier_id = session[:supplier_id]
    @supplier_user.password = 'flk3l343kjl23'
    @supplier_user.invite!
    redirect_to supplier_path(session[:supplier_id])
  end
end
