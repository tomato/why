module CustomersHelper
  def link_to_invitation(customer)
    if(customer.status == :active)
      return
    elsif(customer.status == :new)
      link_to 'Invite', invite_customer_path(customer)
    else
      link_to 'Re-Send Invite', invite_customer_path(customer)
    end
  end
    
end
