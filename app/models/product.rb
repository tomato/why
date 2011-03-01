class Product < ActiveRecord::Base
  belongs_to :supplier
  has_many :order_items, :dependent => :destroy
  has_many :regular_order_items, :dependent => :destroy
  validates_presence_of :name
  validates_numericality_of :price, :allow_blank => true
  validates_format_of :category, :with => /\A[\w\s\-]+\z/,
    :message => "Sorry no special characters (apostrophes, ampersands etc) are allowed in category names", :allow_blank => true
  before_save :set_category_sequence

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

  def self.get_grouped(supplier)
    Product.find_all_by_supplier_id(supplier.id).sort.group_by { |c| [c.category_sequence, c.category] }
  end

  def set_category_sequence
    if(self.category_changed? || self.new_record?)
      s = Product.where(:category => self.category).order("sequence desc").first
      if(s) then
        self.category_sequence = s.category_sequence 
        self.sequence = s.sequence + 1
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
