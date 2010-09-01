module Authable

  def invite!
    generate_invitation_token
    save!
    self.class.send_invitation(email)
  end

end
