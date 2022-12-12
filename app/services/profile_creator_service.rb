class ProfileCreatorService

  def create_profile(params)

    ActiveRecord::Base.transaction do
      
      user_attributes = params.dig(:user_attributes)
    
      user = User.create!(user_attributes)
      
      role = find_role(params)
      user.add_role :"#{role.name}"

      if user.has_role? :manager
        PoolContainer.create(user: user)
      end

      grade_id = params.dig(:grade_id)
      grade_attributes = params.dig(:grade_attributes)
      grade = find_grade(grade_id, grade_attributes)
      grade = Grade.create!(grade_attributes) if grade.blank?
      
      speciality_id = params.dig(:speciality_id)
      speciality_attributes = params.dig(:speciality_attributes)
      speciality = find_speciality(speciality_id, speciality_attributes)
      speciality = Speciality.create!(speciality_attributes) if speciality.blank?

      profile_attributes = { first_name: params.dig(:first_name), last_name: params.dig(:last_name) }
      profile_attributes.merge!(user: user, grade: grade, speciality: speciality)
      Profile.create!(profile_attributes)
    end
  end

  private

  def find_grade(grade_id, grade_attributes)
    grade = nil
    grade = Grade.find_by(id: grade_id) if grade_id.present?
    grade = Grade.find_by(grade_attributes) if grade.blank?
    
    grade
  end

  def find_speciality(speciality_id, speciality_attributes)
    speciality = nil
    speciality = Speciality.find_by(id: speciality_id) if speciality_id.present?
    speciality = Speciality.find_by(speciality_attributes) if speciality.blank?
    
    speciality
  end

  def find_role(params)
    role_id = params.dig(:user_attributes, :role_ids)
    role = Role.find_by(id: role_id)
  end
end
