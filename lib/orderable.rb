module Orderable
  
  def export_fields
    [self.note|| nil] + items.map{ |i| [i.quantity, i.product.name, i.product.price.to_s]}.flatten
  end

  def to_csv
    ((customer.export_fields||[]) + (export_fields||[])).to_csv
  end
  
  def label_lines
    returning Array.new do |arr|
      arr << customer.name
      arr << customer.address
      arr << customer.postcode
      arr << customer.telephone
      items.each{|i| arr << "#{i.quantity} x #{i.product.name}" }
    end
  end
  

end
