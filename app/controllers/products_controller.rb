class ProductsController < ApplicationController
  before_filter :authenticate_supplier!
  
  def index
    @products = Product.find_all_by_supplier_id(session[:supplier_id])
    @product_categories = @products.group_by { |c| c.category }
  end

  def new
    @product = Product.new
    @category_list = Product.find_all_by_supplier_id(
      session[:supplier_id], :group => 'category').join(',')
    render :action => 'edit'
  end

  def edit
    @product = Product.find(params[:id])
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
    @product = Product.find(params[:id])
    if(@product.update_attributes(params[:product]))
      redirect_to products_path
    else
      render :action => 'edit'
    end

  end

end
