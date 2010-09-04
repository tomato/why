module Authable

  def invite!
    generate_invitation_token
    save!
    self.invite
  end

end
