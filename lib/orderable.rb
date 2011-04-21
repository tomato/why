module Orderable
  
  def export_fields
    [self.note|| nil] + items.map{ |i| [i.quantity, i.product.name, i.product.price.to_s]}.flatten
  end

  def to_csv
    ((customer.export_fields||[]) + (export_fields||[])).to_csv
  end
  
  def archive
    o = ArchivedOrder.new(
      :delivery_id => self[:delivery_id],
      :customer_id => self[:customer_id],
      :originally_created_at => self[:created_at],
      :originally_updated_at => self[:updated_at],
      :note => self[:note])
    items.each do |i|
      o.archived_order_items << ArchivedOrderItem.new(
          :product_id => i.product_id,
          :quantity => i.quantity,
          :product_name => i.product.name,
          :price => i.product.price)
        end
    o.save
  end

  def label_lines
    returning Array.new do |arr|
      arr << customer.name
      arr << customer.address
      arr << customer.postcode
      arr << customer.telephone
      arr << note if note
      arr << customer.regular_note if customer.regular_note
      items.each{|i| arr << "#{i.quantity} x #{i.product.name}" }
    end
  end
  

end
