FactoryGirl.define do
  factory :opening do
    title Faker::Name.name
    country 'US'
    province '2'
    department_id 1
    hiring_manager_id 1
    recruiter_id  1
    description (Random.rand * 10000).to_i.to_s
    status  1
  end
end