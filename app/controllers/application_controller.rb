class ApplicationController < ActionController::Base
  include UrlHelper
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_supplier
  before_filter :set_mailer_url_options
  layout :layout

  protected

  def after_sign_in_path_for(resource)
    logger.info "firing after_sign_in_path from #{ request.referer }"
    #if customer and embeded and url contains invitation/accept?invitation_token redirect to parent_url

    if resource.is_a?(SupplierUser) || resource == :supplier_user
      if supplier_user_signed_in?
        supplier_url current_supplier_user.supplier_id
      else
        new_supplier_user_session
      end
    elsif resource.is_a?(Admin) || resource == :admin
       home_url
    elsif resource.is_a?(Customer) || resource == :customer
      if(@supplier && @supplier.embed? && request.referer.include?('invitation'))
        logger.info "Customer redirecting to parent url"
        return @supplier.parent_url
      else
        session[:supplier_id] = current_customer.supplier_id
        logger.info "Customer about to redirect to orders"
        customer_orders_url(current_customer.id)
      end
    else
      logger.info "Calling super #{ resource.inspect }"
      super
    end
  end
  

  def after_sign_out_path_for(resource)
    super
  end
   
  def authenticate_supplier!
    if(valid_superuser?)
      return
    elsif supplier_user_signed_in?
      flash[:notice] = 'You may not access this page, it belongs to another supplier'
    end
    logger.info "Authenticate supplier about to redirect home"
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
      if(request.subdomain.present? && !(request.subdomain =~ /www/i))
        @supplier = Supplier.find(request.subdomain)
        logger.info "Supplier=#{@supplier.name}"
      end
    rescue
      logger.error "Invalid Subdomain #{ request.subdomain } redirecting to #{ home_url(:subdomain => false) }"
      flash[:alert] = "Invalid Subdomain"
      redirect_to home_url(:subdomain => false)
    end
  end

  def layout
    session[:embed] ? 'embed' : 'application'
  end
end
