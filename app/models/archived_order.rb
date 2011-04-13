class ArchivedOrder < ActiveRecord::Base
  has_many :archived_order_items
end
