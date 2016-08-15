namespace :db do
  desc "Fill database with sample data"
  task fill: :environment do
    100.times do |n|
      name = "E#{n+100}"
      about = Faker::Lorem.paragraph(6)
      danger = Faker::Number.between(0, 5)
      category = Faker::Hipster.word
      source = Faker::Internet.url
      FoodAdditive.create!(name: name,
                           about: about,
                           danger: danger,
                           category: category,
                           source: source)
    end
  end
end
