require 'rails_helper'
require 'csv'

RSpec.describe CsvImportUsersService do
  describe 'import good file' do
    let(:file) { Rack::Test::UploadedFile.new(Rails.root.join('spec/activeadmin/units/test_ok.csv'), 'csv') }
    
    subject { CsvImportUsersService.new.convert_save(file) }
    
    it 'create user from csv file' do
      expect { subject }.to change { User.count }.by(1)
    end

    it 'create profile from csv file' do
      expect { subject }.to change { Profile.count }.by(1)
    end

    it 'create grade from csv file' do
      expect { subject }.to change { Grade.count }.by(1)
    end

    it 'create speciality from csv file' do
      expect { subject }.to change { Speciality.count }.by(1)
    end

    it 'check user params' do
      subject
      expect(User.first.email).to eq 'test@gmail.com'
      expect(Profile.first.first_name).to eq 'Vadim'
      expect(Profile.first.last_name).to eq 'Stepanov'
      expect(Grade.first.name).to eq 'trainee'
      expect(Grade.first.level).to eq 'D0'
      expect(Speciality.first.name).to eq 'Front-end'
    end
  end

  describe 'import faild file' do
    let(:file_fail) { Rack::Test::UploadedFile.new(Rails.root.join('spec/activeadmin/units/test_fail.csv'), 'csv') }
    subject { CsvImportUsersService.new.convert_save(file_fail) }

    User.create(email: 'test5@gmail.com', password: 'password', password_confirmation: 'password')

    it 'email repeated user not created' do
      expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
