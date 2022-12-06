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

  def pool_snapshots_by_date(date_string)
    select_date = Date.parse(date_string)
    first_date = select_date.beginning_of_month
    last_date = select_date.end_of_month

    pool_snapshots.where(created_at: first_date..last_date)
  end
end
