require 'spec_helper'

describe InterviewsController do

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
      :scheduled_at => DateTime.now.to_s,
      :duration     => 1,
      :location     => Faker::Address.building_number
    }
    hash = hash.merge :interviewer_ids => users.map { |user| user.id } if users.is_a?(Array)
    hash
  end

  before :all do
    @candidate = Candidate.create! valid_candidate
    @opening = OpeningCandidate.create! valid_opening_candidate
    @users = []
    3.times do
      @users << User.create!(:name => Faker::Name.name, :email => Faker::Internet.email + UUIDTools::UUID.random_create.to_s)
    end
    @user_ids = @users.map { |user| user.id }
  end

  before :each  do
    request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in_as_admin
  end

  describe "GET index" do
    it "assigns all interviews as @interviews" do
      interview = Interview.create! valid_interview
      get :index, {} 
      assigns(:interviews).should eq([interview])
    end
  end

  describe "GET show" do
    it "assigns the requested interview as @interview" do
      interview = Interview.create! valid_interview
      get :show, { :id => interview.to_param } 
      assigns(:interview).should eq(interview)
    end
  end

  describe "GET new" do
    it "assigns a new interview as @interview" do
      get :new, { :candidate_id => @opening.candidate_id }
      assigns(:interview).should be_a_new(Interview)
    end
  end

  describe "GET edit" do
    it "assigns the requested interview as @interview" do
      interview = Interview.create! valid_interview
      get :edit, { :id => interview.to_param } 
      assigns(:interview).should eq(interview)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Interview" do
        expect do
          post :create, { :interview => valid_interview, :opening_candidate_id => @opening.id }
        end.to change(Interview, :count).by(1)
      end

      it "assigns a newly created interview as @interview" do
        post :create, { :interview => valid_interview, :opening_candidate_id => @opening.id }
        assigns(:interview).should be_a(Interview)
        assigns(:interview).should be_persisted
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved interview as @interview" do
        Interview.any_instance.stub(:save).and_return(false)
        post :create, { :interview => {}, :opening_candidate_id => @opening.id }
        assigns(:interview).should be_a_new(Interview)
      end

      it "re-renders the 'edit' template" do
        Interview.any_instance.stub(:save).and_return(false)
        post :create, { :interview => {}, :opening_candidate_id => @opening.id }
        response.should render_template("edit")
      end
    end

    describe "with interviewers" do
      it "create a new Interview with interviewers" do
        post :create, { :interview => valid_interview(@users), :opening_candidate_id => @opening.id }
        assigns(:interview).should be_a(Interview)
        assigns(:interview).should have(@users.size).interviewers
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested interview" do
        interview = Interview.create! valid_interview
        Interview.any_instance.should_receive(:update_attributes).with({ 'these' => 'params' })
        put :update, { :id => interview.to_param, :interview => { 'these' => 'params' } } 
      end

      it "assigns the requested interview as @interview" do
        interview = Interview.create! valid_interview
        put :update, { :id => interview.to_param, :interview => valid_interview } 
        assigns(:interview).should eq(interview)
      end
    end

    describe "with invalid params" do
      it "assigns the interview as @interview" do
        interview = Interview.create! valid_interview
        Interview.any_instance.stub(:save).and_return(false)
        put :update, { :id => interview.to_param, :interview => {} } 
        assigns(:interview).should eq(interview)
      end

      it "re-renders the 'edit' template" do
        interview = Interview.create! valid_interview
        Interview.any_instance.stub(:save).and_return(false)
        put :update, { :id => interview.to_param, :interview => {} } 
        response.should render_template("edit")
      end
    end

    describe "with interviewers" do
      it "adds interviewers" do
        interview = Interview.create! valid_interview
        put :update, { :id => interview.to_param, :interview => { :interviewer_ids => @user_ids } }
        assigns(:interview).should have(@users.size).interviewers
      end

      it "removes interviewers" do
        interview = Interview.create! valid_interview(@users)
        put :update, { :id => interview.to_param, :interview => { :interviewer_ids => @user_ids[1..-1] } }
        assigns(:interview).should have(@users.size - 1).interviewers
        assigns(:interview).interviewers.map { |interviewer| interviewer.user_id }.should_not include(@user_ids[0])
      end

      it "adds and removes interviewers" do
        interview = Interview.create! valid_interview(@users[1..-1])
        put :update, { :id => interview.to_param, :interview => { :interviewer_ids => @user_ids[0..-2] } }
        assigns(:interview).should have(@users.size - 1).interviewers
        assigns(:interview).interviewers.map { |interviewer| interviewer.user_id }.should include(@user_ids[0])
        assigns(:interview).interviewers.map { |interviewer| interviewer.user_id }.should_not include(@user_ids[-1])
      end
    end
  end
end
