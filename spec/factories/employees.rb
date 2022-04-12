FactoryBot.define do
  factory :employee, aliases: [:receiver, :giver] do
    email { 'employee@example.com' }
    password { 'password321'}
  end
end
