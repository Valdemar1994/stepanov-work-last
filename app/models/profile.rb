class Profile < ApplicationRecord
  belongs_to :speciality
  belongs_to :grade
  belongs_to :user
  has_one :pool

  validates :first_name, :last_name, :grade_id, :speciality_id, :user_id, presence: true
  accepts_nested_attributes_for :user, :grade, :speciality

  scope :available, -> { where.not(id: Pool.pluck(:profile_id)) }
  scope :by_grade, ->(grade_id) { where(grade_id: grade_id) }
  scope :by_speciality, ->(speciality_id) { where(speciality_id: speciality_id) }
end
