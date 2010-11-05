class RegularOrderItem < ActiveRecord::Base
  belongs_to :regular_order
  belongs_to :product
  
  def is_required_for_delivery(this_delivery)
    deliveries = Delivery.where('round_id = :round_id and date >= :first and date <= :this_date', 
                                :round_id => this_delivery.round_id, 
                                :first => self.first_delivery_date,
                                :this_date => this_delivery.date)
    deliveries.include?(this_delivery) && deliveries.index(this_delivery) % self.frequency == 0
  end
end
