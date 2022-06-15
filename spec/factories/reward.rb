require 'faker'

FactoryBot.define do
  factory :reward do
    title { Faker::Book.title }
    description { Faker::Hipster.paragraph_by_chars(characters: 40) }
    price { 1 }
  end
end
