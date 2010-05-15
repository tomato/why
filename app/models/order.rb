class Order < ActiveRecord::Base
  belongs_to :customer
  belongs_to :delivery
  has_many :order_items

  def self.find_candidates(customer)
    deliveries = Delivery.all(:conditions => 
        ["round_id = ? and date >= curdate()", customer.round_id], :limit => 12
    )
    
    deliveries.map do |d| 
      Order.new({
        :customer => customer, 
        :delivery => d})
    end

  end
end
