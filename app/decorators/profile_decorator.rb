class ProfileDecorator < ApplicationDecorator
  delegate_all
  
  def full_name_and_grade
    "#{profile.first_name} #{profile.last_name} / #{profile.grade.name}"
  end
end
