require 'faker'

FactoryBot.define do
  factory :reward do
    title { Faker::Code.unique.npi }
    description { Faker::Hipster.unique.paragraph_by_chars(characters: 40) }
    price { 1 }
    delivery_method { 'online' }
  end
end
