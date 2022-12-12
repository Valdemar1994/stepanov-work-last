FactoryBot.define do
    factory :grade do
      name  { FFaker::Name.unique.name }
      level { FFaker::Name.unique.name }
    end
end
