class Order < ActiveRecord::Base
  include Orderable

  belongs_to :customer
  belongs_to :delivery
  has_many :order_items, :dependent => :delete_all

  validates_presence_of :delivery_id, :customer_id

  def items
    order_items
  end

  def self.find_candidates(customer)
    Delivery.all(:conditions => 
      ["round_id = ? and last_order >= curdate()", customer.round_id], 
        :limit => 12, :order => "date asc"
    ).map do |d| 
      Order.find_by_delivery_id_and_customer_id(d.id, customer.id) || 
      Order.new_for_delivery(customer, d)
    end
  end

  def self.new_for_delivery(customer, delivery)
    o = Order.new(:customer => customer,
                  :delivery => delivery)
    ro = RegularOrder.where(:customer_id => customer.id).first
    if(ro) then
      ro.items.each do |i|
        if i.is_required_for_delivery delivery then
          o.items << OrderItem.new(:product => i.product, :quantity => i.quantity)
        end
      end
    end
    return o
  end

  def self.find_pending_updates(supplier_id)
    Order.all(:joins => :customer,
              :conditions =>
      ["supplier_id = ? and pending_update = 1", supplier_id])
  end

  def self.create_all(params, by_customer = false)
    orders = []
    return orders unless params['orders']
    params['orders'].each do |k,v|
      delivery_id, customer_id = v['delivery_id'], params['customer_id']
      order = Order.find_by_delivery_id_and_customer_id(delivery_id, customer_id)
      if(!order)
        order = Order.new(:delivery_id => v['delivery_id'],
                   :customer_id => params['customer_id'])
      end
      order.note = v['note']
      order.pending_update = 1 #if by_customer

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
