module OrdersHelper
  def submit_text
    if(supplier_user_signed_in? || admin_signed_in?)
      "Update Customer Order"
    else
      "Update My Order"
    end
  end
end
