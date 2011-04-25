class ArchivedOrderItem < ActiveRecord::Base
  belongs_to :archived_order
  belongs_to :product
end
