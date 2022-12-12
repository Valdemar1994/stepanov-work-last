require 'rails_helper'

RSpec.describe 'Grade', :js, type: :feature do
  let!(:admin_user) { create :admin_user }
  let!(:grade) { create :grade }

  describe "#Index grade test", type: :feature do

    scenario 'create new grade' do
    sign_in(admin_user)

    visit admin_grades_path
    click_link('New Grade')

    within('form') do
      find_field(name: 'grade[name]').set('test')
      find_field(name: 'grade[level]').set('D1')
      click_on 'Create Grade'
    end

      expect(page).to have_content 'Grade was successfully created.'
      expect(page).to have_content 'test'
      expect(page).to have_content 'D1'
    end

    scenario 'edit grade' do
      sign_in(admin_user)
    
      visit admin_grades_path
      click_link('Edit')
    
      within('form') do
        find_field(name: 'grade[name]').set('edit_field')
        click_on 'Update Grade'
      end
    
      expect(page).to have_content 'Grade was successfully updated'
      expect(page).to have_content 'edit_field'
    end
  end

  scenario 'destroy grade' do
    sign_in(admin_user)
  
    visit admin_grades_path
    click_link('Delete')
    page.driver.browser.switch_to.alert.accept

    expect(page).to have_content 'Grade was successfully destroyed.'
  end

  describe "#Show grade test", type: :feature do
    
    scenario 'edit grade' do
        sign_in(admin_user)
      
        visit admin_grade_path(Grade.first)
        click_link('Edit Grade')
      
        within('form') do
          find_field(name: 'grade[name]').set('edit_field')
          click_on 'Update Grade'
        end
      
        expect(page).to have_content 'Grade was successfully updated'
        expect(page).to have_content 'edit_field'
      end
    
    scenario 'destroy grade' do
      sign_in(admin_user)
    
      visit admin_grade_path(Grade.first)
      click_link('Delete Grade')
      page.driver.browser.switch_to.alert.accept

      expect(page).to have_content 'Grade was successfully destroyed.'
    end
  end
end
