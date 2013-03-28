require 'spec_helper'

describe InterviewsController do

  let :valid_candidate do
    {
      :name => Faker::Name.name,
      :email => Faker::Internet.email,
      :phone => Faker::PhoneNumber.phone_number
    }
  end

  def valid_interview
    {
      :candidate_id => @candidate.id,
      :modality     => Interview::MODALITY_PHONE,
      :title        => "interview for David",
      :description  => "30 minutes discussion",
      :status       => Interview::STATUS_NEW,
      :phone        => Faker::PhoneNumber.phone_number,
      :scheduled_at => DateTime.now.to_s,
      :duration     => 1,
      :location     => Faker::Address.building_number
    }
  end

  before :all do
    @candidate = Candidate.create! valid_candidate
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
      get :new, { :candidate_id => @candidate.id }
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
          post :create, { :interview => valid_interview, :candidate_id => @candidate.id }
        end.to change(Interview, :count).by(1)
      end

      it "assigns a newly created interview as @interview" do
        post :create, { :interview => valid_interview, :candidate_id => @candidate.id }
        assigns(:interview).should be_a(Interview)
        assigns(:interview).should be_persisted
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved interview as @interview" do
        Interview.any_instance.stub(:save).and_return(false)
        post :create, { :interview => {}, :candidate_id => @candidate.id }
        assigns(:interview).should be_a_new(Interview)
      end

      it "re-renders the 'edit' template" do
        Interview.any_instance.stub(:save).and_return(false)
        post :create, { :interview => {}, :candidate_id => @candidate.id }
        response.should render_template("edit")
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
  end
end
