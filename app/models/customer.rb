class Customer < ActiveRecord::Base
  include Authable
  belongs_to :round
  belongs_to :supplier
  has_many :orders, :dependent => :destroy
  has_many :regular_orders, :dependent => :destroy
  acts_as_indexed :fields => [:name, :email, :address, :postcode, :telephone]
  before_update :remove_orders, :if => Proc.new { |c| c.round_id_changed? }

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :recoverable, :invitable,
         :rememberable, :trackable, :validatable

  DEFAULT_PASSWORD = 'fdjaHjk9099kjflkjl'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :round_id, :supplier_id, :name, :address, :postcode, :telephone
  cattr_reader :per_page
  @@per_page = 8
  
  scope :for_supplier, lambda { |supplier_id| 
    {:conditions => ['supplier_id = ?', supplier_id],
      :order => 'updated_at DESC' }
  }

  def self.search(supplier_id, search)
    if(search.present?)
      for_supplier(supplier_id).with_query('^' + search)
    else
      for_supplier(supplier_id)
    end
  end

  def self.accept_updates(customer_ids)
    return unless customer_ids
    customer_ids.each do |c|
      Customer.find(c).orders.each do |o|
        o.update_attributes(:pending_update => false)
      end
      Customer.find(c).regular_orders.each do |o|
        o.update_attributes(:pending_update => false)
      end
    end
  end
  
  def status
    if(self.invited?)
      :invited
    elsif(valid_password?(DEFAULT_PASSWORD))
      :new
    else
      :active
    end
  end

  def export_fields
    [name, address, postcode, telephone]
  end

  private

  def remove_orders
    logger.info "removing customers orders!"
    orders.each { |o| o.destroy }  if orders
  end
end
