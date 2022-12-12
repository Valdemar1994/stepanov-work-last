FactoryBot.define do
    factory :profile do
      first_name { FFaker::Name.unique.name }
      last_name  { FFaker::Name.unique.name }
    end
end
