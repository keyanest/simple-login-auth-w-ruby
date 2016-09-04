require_relative "session"
require 'csv'



new_start = Session.new

new_start.prepare_database
if !new_start.has_account?
  new_start.create_account
else
  new_start.username_auth

  if !new_start.authorized_username
    new_start.failed_username
  elsif !new_start.pw_validated?
    new_start.failed_password
  else
    new_start.login
  end

end
