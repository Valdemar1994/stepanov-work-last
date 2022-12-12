FactoryBot.define do
    factory :admin_user do
      email                 { FFaker::Internet.email }
      password              { 'password' }
      password_confirmation { 'password' }
    end
  end
