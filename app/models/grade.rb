class Grade < ApplicationRecord

  has_many :profiles, dependent: :restrict_with_error

  validates :name, uniqueness: true
  validates :name, :level, presence: true
  
end
