class OrderFactory 
  def self.find_all_pending(supplier_id)
    RegularOrder.find_pending_updates(supplier_id) + Order.find_pending_updates(supplier_id)  
  end

  def self.pending_customers(supplier_id)
    o = OrderFactory.find_all_pending(supplier_id).group_by(&:customer_id).to_a
    o = o.map{|customer_id, orders| [Customer.find(customer_id), orders]} 
    o.sort{|a,b| a[1][0].updated_at <=> b[1][0].updated_at}

  end
end
