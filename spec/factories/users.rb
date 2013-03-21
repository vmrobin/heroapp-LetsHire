FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
  end

end