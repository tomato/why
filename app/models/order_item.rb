class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates_presence_of :quantity, :order_id, :product_id
  validates_numericality_of :product_id, :greater_than => 0
  validates_numericality_of :quantity
end
