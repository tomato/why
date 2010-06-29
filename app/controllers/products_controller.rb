class ProductsController < ApplicationController
  before_filter :authenticate_supplier!
  
  def index
    @products = Product.find_all_by_supplier_id(@supplier.id).sort
    @product_categories = @products.group_by { |c| [c.category_sequence, c.category] }
  end

  def new
    @product = Product.new
    @category_list = Product.find_all_by_supplier_id(
      @supplier.id, :group => 'category').join(',')
    render :action => 'edit'
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(params[:product].merge(:supplier_id => @supplier.id))
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

  def reorder
    Product.update_sequences(params[:product], @supplier.id)
    Product.update_category_sequences(params[:category], @supplier.id)
    render :update do |page|
      page << "alert('#{escape_javascript(params.inspect)}')"
    end
  end

end
