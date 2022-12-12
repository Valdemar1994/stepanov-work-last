require 'rails_helper'

RSpec.describe ProfileCreatorService do
 
  subject {
    grade = Grade.create(name: 'Test', level: 'D0')
    speciality = Speciality.create(name: 'Speciality')
    user = User.create(email: 'email@gmail.com', password: '123456',
      password_confirmation: '123456')
    profile = Profile.create(first_name: 'Name', last_name: 'Name',
    user_id: user.id, grade_id: grade.id, speciality_id: speciality.id)
  }
  
  describe 'Create' do

    it 'should be valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'should be valid without a speciality id' do
      subject.grade.name = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a speciality id' do
      subject.grade.level = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a speciality id' do
      subject.speciality.name = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a speciality id' do
      subject.user.email = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a speciality id' do
      subject.last_name = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a user id' do
      subject.user_id = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a grade id' do
      subject.grade_id = nil
      expect(subject).not_to be_valid
    end

    it 'should be valid without a speciality id' do
      subject.speciality_id = nil
      expect(subject).not_to be_valid
    end
  end
end
