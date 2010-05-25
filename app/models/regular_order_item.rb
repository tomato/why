class RegularOrderItem < ActiveRecord::Base
  belongs_to :regular_order
  belongs_to :product
end
