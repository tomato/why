class Customer < ActiveRecord::Base
  include Authable
  belongs_to :supplier
  has_many :orders, :dependent => :destroy
  has_many :regular_orders, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :recoverable, :invitable,
         :rememberable, :trackable, :validatable

  DEFAULT_PASSWORD = 'fdjaHjk9099kjflkjl'

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :round_id, :supplier_id, :name, :address, :postcode, :telephone
  
  def status
    if(self.invited?)
      :invited
    elsif(valid_password?(DEFAULT_PASSWORD))
      :new
    else
      :active
    end
  end
end
