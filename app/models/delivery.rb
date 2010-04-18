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

  def self.days
    [[1 , "Monday"], [2 , "Tuesday"], [3 , "Wednesday"], [4 , "Thursday"], [5 , "Friday"], [6 , "Saturday"], [0 , "Sunday"]]
  end
end
