module Authable

  def invite!
    self.invitation_token = Devise.friendly_token unless self.invitation_token.present?
    self.invite
  end

end
