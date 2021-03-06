class RegularOrderItem < ActiveRecord::Base
  belongs_to :regular_order
  belongs_to :product
  
  def is_required_for_delivery(this_delivery)
    deliveries = Delivery.where('round_id = :round_id and date >= :first', 
                                :round_id => this_delivery.round_id, 
                                :first => self.first_delivery_date
                                ).order(:date)
    #frequency should never be 0 but just in case
    self.frequency == 0 || deliveries.include?(this_delivery) && deliveries.index(this_delivery) % self.frequency == 0
  end
end
