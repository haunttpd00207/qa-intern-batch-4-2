5.times do |n|
  name  = Faker::Name.name
  Category.create!(name: name)
end

10.times do |n|
  name  = Faker::Name.name
  Tag.create!(name: name)
end
