# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "\nPlease enter the admin email: "
email = STDIN.gets.chomp

puts "\nPlease enter the admin account name (only letters, numbers and underscores): "
name = STDIN.gets.chomp

puts "\nPlease enter the admin password: "
password = STDIN.noecho(&:gets).chomp

puts "\nPlease enter the admin public key: "
public_key = STDIN.gets.chomp

user = User.new(name: name, password: password, email: email, public_key: public_key, admin: true)

if user.save
  puts 'User saved.'
else
  puts 'Saving user failed. Please rerun rake db:seed'
  user.errors.full_messages.each do |msg|
    puts msg
  end
end
