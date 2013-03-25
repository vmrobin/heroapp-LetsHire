require 'spec_helper'

describe InterviewController do

  def valid_interview
    {
      :type         => Interview::INTERVIEW_TYPE_PHONE,
      :title        => "interview for David",
      :description  => "30 minutes discussion",
      :status       => Interview::INTERVIEW_STATUS_NEW,
      :phone_num    => Faker::PhoneNumber.phone_number,
      :phone_ext    => "4571",
      :date         => DateTime.now.to_date.to_s,
      :time         => "03:57:15",
      :duration     => 1,
      :location     => Faker::Address.building_number
    }
  end

  def invalid_interview
    {
      :description  => "30 minutes discussion",
      :status       => Interview::INTERVIEW_STATUS_NEW,
      :phone_num    => Faker::PhoneNumber.phone_number,
      :phone_ext    => "4571",
      :date         => DateTime.now.to_date.to_s,
      :time         => "03:57:15",
      :duration     => 1,
      :location     => Faker::Address.building_number
    }
  end

  describe "GET 'edit'" do
    it "returns http success" do
      get 'edit'
      response.should be_success
    end
  end

  describe "POST 'create'" do
    describe "with valid params" do
      it "save a new interview" do
        post :create, {:interview => valid_interview}
        assigns(:interview).should be_a(Interview)
      end

      it "returns http success" do
        post :create, {:interview => valid_interview}
        response.should be_success
        response.should render_template("create")
      end
    end

    describe "with invalid params" do
      it "reports error" do
        post :create, {:interview => invalid_interview}
        response.should render_template("edit")
      end

      it "redirects to error page" do
        post :create, {:interview => {}}
        response.code.to_i.should eq(500)
      end
    end
  end

end
