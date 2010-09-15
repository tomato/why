class ApplicationController < ActionController::Base
  include UrlHelper
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_supplier
  before_filter :set_mailer_url_options


  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(SupplierUser) 
      if supplier_user_signed_in?
        supplier_url current_supplier_user.supplier_id
      else
        new_supplier_user_session
      end
    elsif resource.is_a?(Admin)
       home_url
    elsif resource.is_a?(Customer)
      session[:supplier_id] = current_customer.supplier_id
      customer_orders_url(current_customer.id)
    else
      super
    end
  end
  

  def after_sign_out_path_for(resource)
    super
  end
   
  protected
  
  def authenticate_supplier!
    if(valid_superuser?)
      return
    elsif supplier_user_signed_in?
      flash[:notice] = 'You may not access this page, it belongs to another supplier'
    end
    redirect_to home_path
  end

  def valid_superuser?()
    admin_signed_in? || (@supplier && valid_user_for_supplier?(@supplier.id))
  end

  def valid_user_for_supplier?(supplier_id)
    current_supplier_user && current_supplier_user.supplier_id == supplier_id.to_i
  end

  def set_supplier
    begin
      if(request.subdomain.present?)
        @supplier = Supplier.find(request.subdomain)
        logger.info "Supplier=#{@supplier.name}"
      end
    rescue
      logger.error "Invalid Subdomain #{ request.subdomain }"
    end
  end
end
