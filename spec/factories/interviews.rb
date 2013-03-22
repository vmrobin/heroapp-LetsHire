FactoryGirl.define do
  factory :interview do
    type         "phone interview"
    title        "phone interview for Raymond Williamson"
    description  Faker::Lorem.paragraph
    status       "pending"
    score        9.2
    assessment   Faker::Lorem.paragraph
    scheduled_at DateTime.now
    duration     1
    phone        Faker::PhoneNumber.phone_number
    location     Faker::Address.state
    created_at   DateTime.now
    updated_at   DateTime.now
  end
end
