# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  protected

  def authenticate_supplier!(supplier_id = session[:supplier_id])
    #logger.debug "supplier_id=#{ supplier_id}, user_supplier_id=#{current_supplier_user.supplier_id}"  
    #logger.debug "valid_user_for_supplier?=#{ valid_user_for_supplier?(supplier_id)}"
    if(admin_signed_in? || valid_user_for_supplier?(supplier_id))
      return
    elsif supplier_user_signed_in?
      flash[:notice] = 'You may not access this page, it belongs to another supplier'
      authenticate_admin!      
    else
      authenticate_supplier_user!
    end
  end

  def valid_user_for_supplier?(supplier_id)
    current_supplier_user && current_supplier_user.supplier_id == supplier_id.to_i
  end
end
