module Orderable
  
  def export_fields
    items.map{ |i| [i.quantity, i.product.name, i.product.price.to_s]}.flatten
  end

  def to_csv
    (customer.export_fields + export_fields).to_csv
  end

end
