class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  validates_presence_of :quantity, :order_id, :product_id
end
