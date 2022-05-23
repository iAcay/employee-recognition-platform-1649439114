# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'Creating employee accounts'
1.upto(5) do |i|
  Employee.where(email: "employee#{i}@test.com").first_or_create!(password: 'password')
end

puts 'Creating kudos'
1.upto(4) do |i|
  Kudo.where(title: "#{i}.From seed", content: "His work is awesome! He did what he should three times faster than others! Really great!", giver: Employee.find_by(email: "employee#{i}@test.com"), receiver: Employee.find_by(email: "employee#{5 - i}@test.com")).first_or_create!
end

puts 'Creating admin account'
AdminUser.where(email: "admin@test.com").first_or_create!(password: "password")

puts 'Creating company values'
CompanyValue.where(title: "Honesty").first_or_create!
CompanyValue.where(title: "Ownership").first_or_create!
CompanyValue.where(title: "Accountability").first_or_create!
CompanyValue.where(title: "Passion").first_or_create!
