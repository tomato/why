class Delivery < ActiveRecord::Base
  belongs_to :round
  
  def self.create_all(round_id, from, to, days)

  end
end
