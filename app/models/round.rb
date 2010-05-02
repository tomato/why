class Round < ActiveRecord::Base
  has_many :deliverys
  named_scope :for_supplier, lambda { |supplier_id|
    {:conditions => ["supplier_id = ?", supplier_id]}}
end
