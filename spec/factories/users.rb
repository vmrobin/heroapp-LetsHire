FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
    admin false
  end

  factory :admin1 do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
    admin true
  end

  factory :hiring_manager1 do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
    admin false
    roles_mask 5
  end

  factory :recruiter1 do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
    admin false
    roles_mask 3
  end

  factory :recruit_hiring_manager1 do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
    admin false
    roles_mask 7
  end

end