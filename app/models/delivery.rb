class Delivery < ActiveRecord::Base
  belongs_to :round
  has_many :orders

  def all_orders
    (round.customers.map do |c|
      orders.first{|o| o.customer_id = c.id} ||
        c.regular_orders.first
    end).compact.reject{|o| o.items.empty?}
  end
  
  def self.all_orders(delivery_ids)
    Delivery.find(delivery_ids.split(',')).map {|d| d.all_orders}.flatten
  end

  def all_orders_csv
    all_orders.map{|o| o.to_csv}.join
  end

  def self.all_orders_csv(delivery_ids)
    Delivery.find(delivery_ids.split(',')).map {|d| d.all_orders_csv }.join
  end

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

  def self.next_10_dates(supplier_id)
    Delivery.all( :conditions => ['supplier_id = ? and date >= curdate()', supplier_id],
                  :joins => ' inner join rounds on deliveries.round_id = rounds.id',
                  :order => 'date ').group_by(&:date).first(10).map do |d|
                    [d[0], d[1].map{|d| d.id}]
                  end 
  end
end
