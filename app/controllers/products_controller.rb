class ProductsController < ApplicationController
  before_filter :authenticate_supplier!
  
  def index
    @product_categories = Product.get_grouped(@supplier)
  end

  def cat
    @product_categories = Product.get_grouped(@supplier)
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
    params[:product][:description] = '' unless(params[:has_description])
    @product = Product.new(params[:product].merge(:supplier_id => @supplier.id))
    if(@product.save)
      redirect_to products_path
    else
      render :action => 'edit'
    end
  end

  def update
    params[:product][:description] = '' unless(params[:has_description])
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
