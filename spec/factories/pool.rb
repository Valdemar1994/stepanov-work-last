FactoryBot.define do
    factory :pool do
      type       { 'Manager' }
      profile_id { profile }
      parent_id  { nil }
    end
end
