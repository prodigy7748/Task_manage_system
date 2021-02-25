FactoryBot.define do
  factory :task do
    title { Faker::Lorem.sentence }
    start_time { Faker::Time.between(from: DateTime.now - 3.day ,to: DateTime.now - 2.day) }
    end_time { Faker::Time.between(from: DateTime.now - 1.day, to: DateTime.now) }
    priority { 1 }
    status { 1 }
    content { Faker::Lorem.paragraph }
  end
end