class SupplierUser < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :lockable, :timeoutable and :activatable
  devise :authenticatable, :recoverable, :invitable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :supplier_id

  def invite!
    generate_invitation_token
    save!
    send_invitation
  end

end
