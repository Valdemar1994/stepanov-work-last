require 'csv'
require 'ostruct'

class CsvImportUsersService

  attr_accessor :message
  
  def convert_save(csv_file)
    @message = OpenStruct.new(error: '', notice: '')
      
    CSV.foreach(csv_file.path) do |row|
      full_name, email, role, speciality, grade = row
      find_user = User.find_by email: email.strip

      if find_user.present?

        user = find_user
        @message.error += "User #{user.email} alredy exist; "

      else

        ActiveRecord::Base.transaction do
          
          user = User.create!(email: email.strip, password: 'password', password_confirmation: 'password')
          user.add_role role.strip

          if user.has_role? :manager
            PoolContainer.create!(user: user)
          end

          @message.notice += "User #{user.email} created; "
            
          speciality_item = Speciality.find_or_create_by!(name: speciality.strip)

          grade_arr = grade.split('/')
          grade_name = grade_arr[0]
          grade_level = grade_arr[1]
          grade_item = Grade.find_or_create_by!(name: grade_name.strip, level: grade_level.strip)

          full_name_arr = full_name.split(' ')
          first_name = full_name_arr[0]
          last_name = full_name_arr[1]

          Profile.find_or_create_by!(first_name: first_name.strip, last_name: last_name.strip,
          user_id: user.id, speciality_id: speciality_item.id, grade_id: grade_item.id)
        end
      end
    end
  end
end
