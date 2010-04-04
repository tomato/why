# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_why_session',
  :secret      => '91fad7c367911a11a01fcfd49da77e8968c8057c91f0846bb3a947b84192c8b475f131de75ca9d45b6d64116e3da1f43a9980a65d3ee2da2c74bd5cd240cad7f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
