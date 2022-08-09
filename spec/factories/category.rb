FactoryBot.define do
  factory :category do
    title { Faker::Lorem.unique.word }
  end
end
