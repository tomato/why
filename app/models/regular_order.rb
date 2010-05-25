class RegularOrder < ActiveRecord::Base
  belongs_to :customer
  has_many :regular_order_items, :dependent => :delete_all

  validates_presence_of :customer_id

  def self.find_or_new(customer)
    ros = RegularOrder.find_all_by_customer_id(customer.id) 
    if(ros.empty?)
      ros << RegularOrder.new(:customer_id => customer.id)
    end
    return ros
  end

  def self.create_all(params)
    customer_id = params['customer_id']
    regularOrders = []
    
    return regularOrders unless params['regular_orders'] 
    
    params['regular_orders'].each do |k,v|

      if(v['regular_order_id'] == 'undefined')
        regularOrder = RegularOrder.new(:customer_id => params['customer_id'])
      else
        regularOrder = RegularOrder.find(v['regular_order_id'])
      end

      if(regularOrder.save!)
        regularOrder.regular_order_items.clear
        v['items'].each do |k,v|
          regularOrder.regular_order_items << RegularOrderItem.new(v.merge(:regular_order_id => regularOrder.id))
        end
      end

      regularOrders << regularOrder
    end
    return regularOrders
  end
end
