FactoryGirl.define do
  factory :user do
    email Faker::Internet.email
    name Faker::Name.name
    password (Random.rand * 10000).to_i.to_s
    admin false
  end

  factory :recruiter, :class => :User, :parent => :user do
    email "R_#{Faker::Internet.email}"
    roles_mask 3
  end

  factory :hiring_manager, :class => :User, :parent => :user do
    email "HM_#{Faker::Internet.email}"
    roles_mask 5
  end
end