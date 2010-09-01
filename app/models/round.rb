class Round < ActiveRecord::Base
  belongs_to :supplier
  has_many :customers
  has_many :deliverys, :dependent => :destroy
  scope :for_supplier, lambda { |supplier_id|
    {:conditions => ["supplier_id = ?", supplier_id]}}

  before_destroy do |entry| 
    raise ActiveRecord::RecordNotDestroyed unless entry.destroyable?
  end
  
  def destroyable?
    self.customers.empty?
  end
end
