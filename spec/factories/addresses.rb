FactoryBot.define do
  factory :address do
    street { Faker::Address.unique.street_address }
    postcode { Faker::Address.unique.zip_code }
    city { Faker::Address.unique.city }
    employee
  end
end
