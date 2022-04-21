FactoryBot.define do
  factory :admin_user do
    sequence(:email) { |i| "admin#{i}@test.com" }
    password { 'password' }
  end
end
