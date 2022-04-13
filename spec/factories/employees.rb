FactoryBot.define do
  factory :employee, aliases: %i[receiver giver] do
    email { 'employee@example.com' }
    password { 'password321' }
  end
end
