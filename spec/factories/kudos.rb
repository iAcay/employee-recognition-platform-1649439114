FactoryBot.define do
  factory :kudo do
    receiver
    giver
    title { 'Great Worker!' }
    content { 'He did his work three times faster than others.' }
  end
end
