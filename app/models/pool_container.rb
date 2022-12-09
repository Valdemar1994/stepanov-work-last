class PoolContainer < ApplicationRecord
    
  has_many :pools
  belongs_to :user

  def filtered_pools(filter_params)
    grade_id = filter_params[:grade_id]
    speciality_id = filter_params[:speciality_id]
    
    pools_scope = pools

    if grade_id.present? || speciality_id.present?
      profile_scope = Profile.all

      profile_scope = profile_scope.by_grade(grade_id) if grade_id.present?
      profile_scope = profile_scope.by_speciality(speciality_id) if speciality_id.present?
      pools_scope = pools_scope.where(profile_id: profile_scope.ids)
    end
    pools_scope
  end
end
