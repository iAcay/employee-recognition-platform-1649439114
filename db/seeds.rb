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
  print '✔'
end
puts '✅'

puts 'Creating admin account'
AdminUser.where(email: "admin@test.com").first_or_create!(password: "password")
print '✔'
puts '✅'

puts 'Creating company values'
%w[Honesty Ownership Accountability Passion].each do |company_value_title|
  CompanyValue.where(title: company_value_title).first_or_create!
  print '✔'
end
puts '✅'

puts 'Creating kudos'
1.upto(4) do |i|
  Kudo.where(title: "#{i}.From seed", content: "His work is awesome! He did what he should three times faster than others! Really great!", giver: Employee.all.sample, receiver: Employee.all.sample, company_value: CompanyValue.all.sample).first_or_create!
  print '✔'
end
puts '✅'

puts 'Creating rewards'
1.upto(5) do |i|
  Reward.where(title: "Reward no. #{i}.", description: "Description of reward no. #{i}.", price: i).first_or_create!
  print '✔'
end
puts '✅'
