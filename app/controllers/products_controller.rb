class ProductsController < ApplicationController
  def new
    @product = Product.new
    @categories = Product.find_all_by_supplier_id(
      session[:supplier_id], :group => 'category')
    render :action => 'edit'
  end

  def edit
  end

  def create
    @product = Product.new(params[:product].merge(:supplier_id => session[:supplier_id]))
    if(@product.save)
      redirect_to products_path
    else
      render :action => 'edit'
    end
  end

  def update

  end
end
