require 'rails_helper'

RSpec.describe 'Authentication test', :js, type: :feature do
  describe 'authentication' do
    scenario 'success sign in' do

      user = User.create!(email: 'user@example.com', password: 'password', password_confirmation: 'password')
      user.add_role :manager

      visit user_session_path

        fill_in 'Email address', with: 'user@example.com'
        fill_in 'Password', with: 'password'
        click_button 'Sign in'

      expect(page).to have_current_path(root_path)
    end
  end
end
