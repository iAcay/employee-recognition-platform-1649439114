FactoryBot.define do
  factory :employee, aliases: %i[receiver giver] do
    sequence(:email) { |i| "employee#{i}@test.com" }
    password { 'password321' }
  end
end
