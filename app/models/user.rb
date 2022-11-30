class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  has_one :profile
  has_one :pool_container

  def pool_snapshots
    ActiveSnapshot::Snapshot.where(user: self).includes(:user)
  end
end
