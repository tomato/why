class Delivery < ActiveRecord::Base
  belongs_to :round
  has_many :orders
  scope :for_supplier, lambda { |supplier| where('supplier_id = ?', supplier.id).joins(' inner join rounds on deliveries.round_id = rounds.id')}

  def all_orders
    (round.customers.map do |c|
      orders.find(:first, :conditions => ["customer_id = ?", c.id]) ||
        Order.new_for_delivery(c, self)
    end).compact.reject{|o| o.items.empty?}
  end
  
  def self.all_orders(delivery_ids)
    Delivery.find(delivery_ids.split(',')).map {|d| d.all_orders}.flatten
  end

  def all_orders_csv
    all_orders.map{|o| date.to_date.to_s(:short) + ',' + o.to_csv}.join
  end

  def self.all_orders_csv(delivery_ids)
    Delivery.find(delivery_ids.split(',')).map {|d| d.all_orders_csv }.join
  end

  def all_produce
    items = all_orders.inject([]){|s,o| s << o.items }.flatten
    produce = []
    round.supplier.products.each do |p|
      product_items = items.find_all{|i| i.product_id == p.id}
      total_quantity =  product_items.inject(0) do |t,i|
        t += i.quantity    
      end
      produce << [p.id,p.name, p.price, total_quantity] unless total_quantity == 0
    end
    return produce
  end

  def all_produce_csv
    all_produce.map{|o| o.to_csv}.join
  end

  def self.all_produce_csv(delivery_ids)
    Delivery.find(delivery_ids.split(',')).map {|d| d.all_produce_csv }.join
  end

  def self.create_all(round_id, from, to, days, last_orders_duration)
    count = 0
    existing_dates = Delivery.find_all_by_round_id(round_id).collect{|i| i.date}
    (from..to).each do |date|
      if(days.include?(date.wday) && !existing_dates.include?(date))
        if(Delivery.create(:date => date, :round_id => round_id, :last_order => date - last_orders_duration.to_i.seconds))
          count+=1
        end
      end
    end
    count
  end

  def self.days
    [[1 , "Monday"], [2 , "Tuesday"], [3 , "Wednesday"], [4 , "Thursday"], [5 , "Friday"], [6 , "Saturday"], [0 , "Sunday"]]
  end

  def self.next_dates(supplier_id, number)
    Delivery.all( :conditions => ['supplier_id = ? and date >= curdate()', supplier_id],
                  :joins => ' inner join rounds on deliveries.round_id = rounds.id',
                  :order => 'date ').group_by(&:date).to_a.first(number).map do |d|
                    d[0]
                  end 
  end

  def self.next_dates_for_round(round_id, number)
    Delivery.all( :conditions => ['round_id = ? and date >= curdate()', round_id],
                  :order => 'date ').group_by(&:date).to_a.first(number).map do |d|
                    d[0]
                  end 
  end

  def self.ids_for_dates(supplier, one_date, start_date, end_date)
    if one_date.present? then
      d = Delivery.for_supplier(supplier).where('date = ?', one_date)
    elsif start_date.present? && end_date.present? then
      d = Delivery.for_supplier(supplier).where('date between ? and ?', start_date, end_date)
    else
      d = []
    end
    return d.map{|a| a.id}
  end
end
