FactoryBot.define do
  factory :employee, aliases: %i[receiver giver] do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    sequence(:email) { |i| "employee#{i}@test.com" }
    password { 'password321' }
  end
end
