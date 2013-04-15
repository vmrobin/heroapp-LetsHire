require 'spec_helper'

describe Interview do
  it 'has a valid interview' do
    @user = FactoryGirl.create(:user)
    @user.should be_valid
    FactoryGirl.build(:interview, :interviewer_ids => [@user.id]).should be_valid
  end

  it 'requires modality to be valid' do
    result = FactoryGirl.build(:interview, :modality => nil)
    result.should_not be_valid
    result.errors.messages.has_key?(:modality).should be_true
    result = FactoryGirl.build(:interview, :modality => 'Invalid Value')
    result.should_not be_valid
    result.errors.messages.has_key?(:modality).should be_true
  end

  it 'requires interviewers to be present' do
    result = FactoryGirl.build(:interview)
    result.should_not be_valid
    result.errors.messages.has_key?(:interviewer_ids).should be_true
  end

  it 'requires title to be present' do
    result = FactoryGirl.build(:interview, :title => nil)
    result.should_not be_valid
    result.errors.messages.has_key?(:title).should be_true
  end

  it 'requires scheduled_at to be present' do
    result = FactoryGirl.build(:interview, :scheduled_at => nil)
    result.should_not be_valid
    result.errors.messages.has_key?(:scheduled_at).should be_true
  end

  it 'requires status to be valid values' do
    result = FactoryGirl.build(:interview, :status => 'Invalid Status')
    result.should_not be_valid
    result.errors.messages.has_key?(:status).should be_true
  end

  describe 'interviewers' do
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

    def valid_interview
      {
          :opening_candidate_id => @opening.id,
          :modality     => Interview::MODALITY_PHONE,
          :title        => "interview for David",
          :description  => "30 minutes discussion",
          :status       => Interview::STATUS_NEW,
          :phone        => Faker::PhoneNumber.phone_number,
          :scheduled_at => DateTime.now.to_s,
          :duration     => 1,
          :interviewer_ids => [@users[0].id]
      }
    end

    before :all do
      @candidate = Candidate.create! valid_candidate
      @opening = OpeningCandidate.create! valid_opening_candidate
      @users = []
      3.times do
        @users << User.create!(:name => Faker::Name.name, :email => Faker::Internet.email + UUIDTools::UUID.random_create.to_s)
      end
    end

    before :each do
      @interview = Interview.create! valid_interview
    end

    it 'adds interviewers' do
      @interview.update_attributes! :interviewer_ids => @users.map { |user| user.id }
      @interview.reload
      @interview.should have(@users.size).interviewers
    end

    it 'removes interviewers' do
      @interview.update_attributes! :interviewer_ids => @users.map { |user| user.id }
      @interview.reload
      @interview.should have(@users.size).interviewers
      @interview.update_attributes! :interviewer_ids => @users[1..-1].map { |user| user.id }
      @interview.should have(@users.size - 1).interviewers
      @interview.reload
      @interview.should have(@users.size - 1).interviewers
      @interview.interviewers.map { |interviewer| interviewer.user_id }.should_not include(@users[0].id)
    end

    it 'adds and removes interviewers' do
      @interview.update_attributes! :interviewer_ids => @users[1..-1].map { |user| user.id }
      @interview.reload
      @interview.should have(@users.size - 1).interviewers
      @interview.interviewers.map { |interviewer| interviewer.user_id }.should_not include(@users[0].id)
      @interview.update_attributes! :interviewer_ids => @users[0..-2].map { |user| user.id }
      @interview.reload
      @interview.should have(@users.size - 1).interviewers
      @interview.interviewers.map { |interviewer| interviewer.user_id }.should include(@users[0].id)
      @interview.interviewers.map { |interviewer| interviewer.user_id }.should_not include(@users[-1].id)
    end

    it 'create with interviewers' do
      interview = Interview.create! valid_interview.merge(:interviewer_ids => @users.map { |user| user.id })
      interview.should have(@users.size).interviewers
    end
  end
end
