class Product < ActiveRecord::Base
  belongs_to :supplier
  validates_presence_of :name
  validates_numericality_of :price, :allow_blank => true

  def self.update_sequences(ids, supplier_id)
    return unless ids
    products = Product.find_all_by_supplier_id(supplier_id)
    ids.each_with_index do |p,i|
      product = products.find{|a| a.id == p.to_i}
      if(product)
        product.sequence = i + 1
        product.save!
      end
    end
  end

  def self.update_category_sequences(ids, supplier_id)
    return unless ids
    products = Product.find_all_by_supplier_id(supplier_id)
    ids.each_with_index do |pid,i|
      cp = products.find{|a| a.id == pid.to_i}
      category = cp ? cp.category : nil
      if(category)
        (products.find_all{|p| p.category == category}).each do |product|
          product.category_sequence = i + 1
          product.save!
        end
      end
    end
  end

  def <=>(other)
    order = category_sequence <=> other.category_sequence
    if order == 0
      sequence <=> other.sequence
    else
      order
    end
  end
end
