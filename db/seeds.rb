# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do |index|
  username = Faker::Internet.username
  email = Faker::Internet.email
  password = "password"
  user = User.create!(  username: username,
                        email: email,
                        password: password,
                        password_confirmation: password)
  title = Faker::Lorem.sentence
  content = Faker::Lorem.paragraph
  tags = "Ruby"
  user.posts.create!( title: title,
                      content: content,
                      all_tags: tags,
                      user_id: user.id)
end
