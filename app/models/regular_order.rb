class RegularOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :regular_order_items, :dependent => :delete_all

  validates_presence_of :customer_id

  def items
    regular_order_items
  end

  def self.find_or_new(customer)
    ros = RegularOrder.find_all_by_customer_id(customer.id) 
    if(ros.empty?)
      ros << RegularOrder.new(:customer_id => customer.id)
    end
    return ros
  end
  
  def self.find_pending_updates(supplier_id)
    RegularOrder.all(:joins => :customer,
              :conditions =>
      ["supplier_id = ? and pending_update = 1", supplier_id])
  end

  def self.create_all(params, by_customer = false)
    customer_id = params['customer_id']
    regularOrders = []
    
    return regularOrders unless params['regular_orders'] 
    
    params['regular_orders'].each do |k,v|

      if(v['regular_order_id'] == 'undefined')
        regularOrder = RegularOrder.new(:customer_id => params['customer_id'])
      else
        regularOrder = RegularOrder.find(v['regular_order_id'])
      end
      regularOrder.pending_update = 1 #if by_customer

      if(regularOrder.save!)
        regularOrder.regular_order_items.clear
        if(v['items'])
          v['items'].each do |k,v|
            regularOrder.regular_order_items << RegularOrderItem.new(v.merge(:regular_order_id => regularOrder.id))
          end
        end
      end

      regularOrders << regularOrder
    end
    return regularOrders
  end
end
