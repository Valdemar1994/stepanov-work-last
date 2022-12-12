class Speciality < ApplicationRecord

  has_many :profiles, dependent: :restrict_with_error

  validates :name, length: { maximum: 255 }, uniqueness: true
  validates :name, presence: true

end
