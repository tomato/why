module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    when /the home page/
      'http://fwig.me'
    when /fred's home\s?page/
      'http://fred.fwig.me'
    when /another site/
      'http://solittlecode.com'
    when /fred's customer\s?page/
      'http://fred.fwig.me/customers'
    when /invalid's customer\s?page/
      'http://invalid.fwig.me/customers'
    when /invite page/
      'http://fred.fwig.me/customers/invitation/accept?invitation_token=pXx3BBJYzOCBXv6tijyG'
    when /reset password page/
      'http://fred.fwig.me/customers/password/edit?reset_password_token=pXx3BBJYzOCBXv6tijyG'
    when /parent page/
      '/how'

    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
