class Customer < ActiveRecord::Base
  include Authable
  belongs_to :supplier

  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :database_authenticatable, :recoverable, :invitable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :round_id, :supplier_id, :name, :address, :postcode, :telephone
end
