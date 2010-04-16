class Delivery < ActiveRecord::Base
  belongs_to :round
  
  def self.create_all(round_id, from, to, days)
    count = 0
    existing_dates = Delivery.find_all_by_round_id(round_id).collect{|i| i.date}
    (from..to).each do |date|
      if(days.include?(date.wday) && !existing_dates.include?(date))
        if(Delivery.create(:date => date, :round_id => round_id))
          count+=1
        end
      end
    end
    count
  end
end
