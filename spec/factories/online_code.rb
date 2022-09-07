FactoryBot.define do
  factory :online_code do
    reward
    code { Faker::Code.unique.ean }
  end
end
