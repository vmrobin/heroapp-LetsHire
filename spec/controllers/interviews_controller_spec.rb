require 'spec_helper'

describe InterviewsController do

  def valid_interview
    {
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

  def invalid_interview
    {
      :description  => "30 minutes discussion",
      :status       => Interview::STATUS_NEW,
      :phone        => Faker::PhoneNumber.phone_number,
      :scheduled_at => DateTime.now.to_s,
      :duration     => 1,
      :location     => Faker::Address.building_number
    }
  end

  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all interviews as @interviews" do
      interview = Interview.create! valid_interview
      get :index, {}, valid_session
      assigns(:interviews).should eq([interview])
    end
  end

  describe "GET show" do
    it "assigns the requested interview as @interview" do
      interview = Interview.create! valid_interview
      get :show, { :id => interview.to_param }, valid_session
      assigns(:interview).should eq(interview)
    end
  end

  describe "GET new" do
    it "assigns a new interview as @interview" do
      get :new, {}, valid_session
      assigns(:interview).should be_a_new(Interview)
    end
  end

  describe "GET edit" do
    it "assigns the requested interview as @interview" do
      interview = Interview.create! valid_interview
      get :edit, { :id => interview.to_param }, valid_session
      assigns(:interview).should eq(interview)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Interview" do
        expect do
          post :create, { :interview => valid_interview }, valid_session
        end.to change(Interview, :count).by(1)
      end

      it "assigns a newly created interview as @interview" do
        post :create, { :interview => valid_interview }, valid_session
        assigns(:interview).should be_a(Interview)
        assigns(:interview).should be_persisted
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved interview as @interview" do
        Interview.any_instance.stub(:save).and_return(false)
        post :create, { :interview => {} }, valid_session
        assigns(:interview).should be_a_new(Interview)
      end

      it "re-renders the 'edit' template" do
        Interview.any_instance.stub(:save).and_return(false)
        post :create, { :interview => {} }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested interview" do
        interview = Interview.create! valid_interview
        Interview.any_instance.should_receive(:update_attributes).with({ 'these' => 'params' })
        put :update, { :id => interview.to_param, :interview => { 'these' => 'params' } }, valid_session
      end

      it "assigns the requested interview as @interview" do
        interview = Interview.create! valid_interview
        put :update, { :id => interview.to_param, :interview => valid_interview }, valid_session
        assigns(:interview).should eq(interview)
      end
    end

    describe "with invalid params" do
      it "assigns the interview as @interview" do
        interview = Interview.create! valid_interview
        Interview.any_instance.stub(:save).and_return(false)
        put :update, { :id => interview.to_param, :interview => {} }, valid_session
        assigns(:interview).should eq(interview)
      end

      it "re-renders the 'edit' template" do
        interview = Interview.create! valid_interview
        Interview.any_instance.stub(:save).and_return(false)
        put :update, { :id => interview.to_param, :interview => {} }, valid_session
        response.should render_template("edit")
      end
    end
  end
end
