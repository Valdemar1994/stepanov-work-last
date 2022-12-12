require "spec_helper"
 
def sign_in(admin_user)
  visit admin_user_session_path
  fill_in 'admin_user_email', with: admin_user.email
  fill_in 'admin_user_password', with: admin_user.password
  click_button 'Login'
end

def login(user)
  visit user_session_path
  fill_in 'Email address', with: user.email
  fill_in 'Password', with: user.password
  click_button 'Sign in'
end
