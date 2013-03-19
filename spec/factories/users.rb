FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    name Faker::Name.name
    password Digest::SHA1.base64digest((Random.rand * 10000).to_i.to_s)
    admin Random.rand >= 0.5
  end
end