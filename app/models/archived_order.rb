class ArchivedOrder < ActiveRecord::Base
  has_many :archived_order_items
  belongs_to :delivery
end
