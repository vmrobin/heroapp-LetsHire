require 'spec_helper'

describe Api::V1::InterviewsController do

  let :valid_candidate do
    {
      :name => Faker::Name.name,
      :email => Faker::Internet.email,
      :phone => Faker::PhoneNumber.phone_number
    }
  end

  let :valid_opening_candidate do
    {
      :candidate_id => @candidate.id,
      :opening_id => 1
    }
  end

  def valid_interview(users = nil)
    hash = {
        :opening_candidate_id => @opening.id,
        :modality     => Interview::MODALITY_PHONE,
        :title        => "interview for David",
        :description  => "30 minutes discussion",
        :status       => Interview::STATUS_NEW,
        :phone        => Faker::PhoneNumber.phone_number,
        :scheduled_at => (DateTime.now + 1.hour).to_s,
        :duration     => 1,
        :location     => Faker::Address.building_number,
        :interviewer_ids => [@user_ids[0]]
    }
    hash = hash.merge :interviewer_ids => users.map { |user| user.id } if users.is_a?(Array)
    hash
  end

  before :all do
    @users = []
    user_password = '12345678'
    3.times do
      @users << User.create!(:name => Faker::Name.name, :email => Faker::Internet.email + UUIDTools::UUID.random_create.to_s, :password => user_password)
    end
    @candidate = Candidate.create! valid_candidate
    @opening = OpeningCandidate.create! valid_opening_candidate
    @user_ids = @users.map { |user| user.id }
  end

  before :each  do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'RESTful API' do

    before :each do
      sign_in_as_admin
    end

    it 'can fetch all interviews in one interval' do
      interview = Interview.create! valid_interview(@users)
      get :index, {}
      assigns(:interviews).should eq([interview])
      get :index, {'interval' => '1w'}
      assigns(:interviews).should eq([interview])
      get :index, {'interval' => '1m'}
      assigns(:interviews).should eq([interview])
    end

    it 'can not fetch any interviews if interval params invalid' do
      interview = Interview.create! valid_interview(@users)
      get :index, {'interval' => 'other'}
      assigns(:interviews).should be_nil
    end

    it 'can fetch specific interview details' do

    end
  end
end