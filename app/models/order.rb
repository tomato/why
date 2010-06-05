class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :delivery
  has_many :order_items, :dependent => :delete_all

  validates_presence_of :delivery_id, :customer_id

  def self.find_candidates(customer)
    Delivery.all(:conditions => 
      ["round_id = ? and date >= curdate()", customer.round_id], :limit => 12
    ).map do |d| 
      Order.find_by_delivery_id_and_customer_id(d.id, customer.id) || Order.new({
        :customer => customer, 
        :delivery => d})
    end

  end

  def self.create_all(params)
    orders = []
    return orders unless params['orders']
    params['orders'].each do |k,v|
      delivery_id, customer_id = v['delivery_id'], params['customer_id']
      order = Order.find_by_delivery_id_and_customer_id(delivery_id, customer_id)
      if(!order)
        order = Order.new(:delivery_id => v['delivery_id'],
                   :customer_id => params['customer_id'])
      end
      if(order.save!)
        order.order_items.clear
        if(v['items'])
          v['items'].each do |k,v|
            order.order_items << OrderItem.new(v.merge(:order_id => order.id))
          end
        end
      end
      orders << order
    end
    return orders
  end
end
