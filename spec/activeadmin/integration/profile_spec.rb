require 'rails_helper'

RSpec.describe 'User', :js, type: :feature do
  let!(:admin_user) { create :admin_user }
  let!(:grade) { create :grade }
  let!(:speciality) { create :speciality }
  let!(:user) { create :user }

  xdescribe "User tests", type: :feature do

    scenario 'create new user' do
      sign_in(admin_user)

  # Create Profile

      visit admin_profiles_path
      click_link('New Profile')

      user.add_role :user

      within('form') do
        find_field(name: 'profile[user_attributes][email]').set('test@gmail.example')
        find_field(name: 'profile[user_attributes][password]').set('password')
        find_field(name: 'profile[user_attributes][password_confirmation]').set('password')
        binding.pry
        find_field(name: 'profile[user_attributes][roles]').find(:option, roles).select_option
        find_field(name: 'profile[first_name]').set('First Name')
        find_field(name: 'profile[last_name]').set('Last Name')
        find_field(name: 'profile[grade_id]').find(:option, grade.name).select_option
        find_field(name: 'profile[speciality_id]').find(:option, speciality.name).select_option

         click_on 'Create Profile'
       end
  
      expect(page).to have_content 'Profile created'
      expect(page).to have_content grade.name
      expect(page).to have_current_path(admin_user_path(User.first))
   
  # Edit User

      click_link('Edit User')
      
      within('form') do
        find_field(name: 'user[password]').set('password')
        find_field(name: 'user[password_confirmation]').set('password')
        find_field(name: 'user[profile_attributes][first_name]').set('Edit First Name')
        click_on 'Update User'
      end
      
      expect(page).to have_content 'User was successfully updated.'
      expect(page).to have_content 'Edit First Name'

  # Destroy User

      click_link('Delete User')
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'User was successfully destroyed.'
    end
  end
end
