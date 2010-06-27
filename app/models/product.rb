class Product < ActiveRecord::Base
  belongs_to :supplier
  validates_presence_of :name
  validates_numericality_of :price, :allow_blank => true

  def self.update_sequences(ids, supplier_id)
    products = Product.find_all_by_supplier_id(supplier_id)
    ids.each_with_index do |p,i|
      product = products.find{|a| a.id = p}
      if(product)
        product.sequence = i + 1
        product.save!
      end
    end
  end

  def <=>(other)
    sequence <=> other.sequence
  end
end
