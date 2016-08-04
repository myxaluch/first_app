namespace :db do
  desc "Fill database with sample data"
  task fill: :environment do
    100.times do |n|
      name = "E#{n+100}"
      about = Faker::Lorem.paragraph(6)
      FoodAdditive.create!(name: name,
                           about: about)
    end
  end
end
