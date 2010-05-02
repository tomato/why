module Authable

  def invite!
    generate_invitation_token
    save!
    send_invitation
  end

end
