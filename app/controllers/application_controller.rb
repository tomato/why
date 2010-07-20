# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  before_filter :set_supplier

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected

  def after_sign_in_path_for(resource)
    if resource.is_a?(SupplierUser) 
      if supplier_user_signed_in?
        supplier_url current_supplier_user.supplier_id
      else
        new_supplier_user_session
      end
    elsif resource.is_a?(Admin)
      redirect_to home_path
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
  
  def authenticate_supplier!(supplier_id = session[:supplier_id])
    #logger.debug "supplier_id=#{ supplier_id}, user_supplier_id=#{current_supplier_user.supplier_id}"  
    #logger.debug "valid_user_for_supplier?=#{ valid_user_for_supplier?(supplier_id)}"
    #logger.debug "supplier_user_signed_in?=#{supplier_user_signed_in? }"
    if(valid_superuser? supplier_id)
      return
    elsif supplier_user_signed_in?
      flash[:notice] = 'You may not access this page, it belongs to another supplier'
    end
    redirect_to home_path
  end

  def valid_superuser?(supplier_id)
    admin_signed_in? || valid_user_for_supplier?(supplier_id)
  end

  def valid_user_for_supplier?(supplier_id)
    current_supplier_user && current_supplier_user.supplier_id == supplier_id.to_i
  end

  def set_supplier
    logger.debug "set_supplier: supplier_id=#{ session[:supplier_id]}"
    @supplier = Supplier.first(:conditions => ["id = ?", session[:supplier_id]])
  end
end
