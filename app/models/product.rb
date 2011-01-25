class Product < ActiveRecord::Base
  belongs_to :supplier
  has_many :order_items, :dependent => :destroy
  has_many :regular_order_items, :dependent => :destroy
  validates_presence_of :name
  validates_numericality_of :price, :allow_blank => true
  validates_format_of :category, :with => /\A[\w\s]+\z/,
    :message => "Sorry no special characters (apostrophes, ampersands etc) are allowed in category names", :allow_blank => true
  before_update :set_category_sequence

  def has_description
    self[:description].present?
  end

  def has_description=(val)
    self[:description] = nil unless(val)
  end

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

  def set_category_sequence
    if(self.category_changed?)
      s = Product.where(:category => self.category).first
      self.category_sequence = s ? s.category_sequence : 0
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
