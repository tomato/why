class ProductsController < ApplicationController
  before_filter :authenticate_supplier!
  
  def index
    @products = Product.find_all_by_supplier_id(@supplier.id).sort
    @product_categories = @products.group_by { |c| [c.category_sequence, c.category] }
  end

  def new
    @product = Product.new
    cat_list()
      
    render :action => 'edit'
  end

  def edit
    cat_list()
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

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end

  def reorder
    begin
      Product.update_sequences(params[:product], @supplier.id)
      Product.update_category_sequences(params[:category], @supplier.id)
      msg = "We re-ordered your products"
    rescue Exception => e
      msg = "This was an error: #{ e.inspect }"
    end
    render :update do |page|
      page << "why.updateReorder(\"#{escape_javascript(msg)}\")"
    end
  end

  private

  def cat_list
    @category_list = Product.select('category').where(:supplier_id => @supplier.id).group('category').map{|p| p.category}.join(',')
  end

end
