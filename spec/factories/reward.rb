require 'faker'

FactoryBot.define do
  factory :reward do
    title { Faker::Book.unique.title }
    description { Faker::Hipster.unique.paragraph_by_chars(characters: 40) }
    price { 1 }
    delivery_method { 'online' }
  end
end
