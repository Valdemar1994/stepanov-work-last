require 'rails_helper'

RSpec.describe 'Speciality', :js, type: :feature do
  let!(:admin_user) { create :admin_user }
  let!(:speciality) { create :speciality }

  describe "#Index speciality test", type: :feature do

    scenario 'create new speciality' do
    sign_in(admin_user)

    visit admin_specialities_path
    click_link('New Speciality')

    within('form') do
      find_field(name: 'speciality[name]').set('new_speciality')
      click_on 'Create Speciality'
    end

      expect(page).to have_content 'Speciality was successfully created.'
      expect(page).to have_content 'new_speciality'
    end

    scenario 'edit speciality' do
      sign_in(admin_user)
    
      visit admin_specialities_path
      click_link('Edit')
    
      within('form') do
        find_field(name: 'speciality[name]').set('edit_speciality')
        click_on 'Update Speciality'
      end
    
      expect(page).to have_content 'Speciality was successfully updated'
      expect(page).to have_content 'edit_speciality'
    end
  
    scenario 'destroy speciality' do
        sign_in(admin_user)
    
        visit admin_specialities_path
        click_link('Delete')
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content 'Speciality was successfully destroyed.'
    end
  end

  describe "#Show speciality test", type: :feature do
    
    scenario 'edit speciality' do
        sign_in(admin_user)
      
        visit admin_speciality_path(Speciality.first)
        click_link('Edit Speciality')
      
        within('form') do
          find_field(name: 'speciality[name]').set('edit_speciality')
          click_on 'Update Speciality'
        end
      
        expect(page).to have_content 'Speciality was successfully updated'
        expect(page).to have_content 'edit_speciality'
      end
    
    scenario 'destroy speciality' do
      sign_in(admin_user)
    
      visit admin_speciality_path(Speciality.first)
      click_link('Delete Speciality')
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'Speciality was successfully destroyed.'
    end
  end
end
