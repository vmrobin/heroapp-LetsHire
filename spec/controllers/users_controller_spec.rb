require 'spec_helper'

describe UsersController do
  def valid_attributes
    {
      :email    => 'test@test.com',
      :password => 'testtest323232',
      :name     => 'test_user'
    }
  end

  before :each do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in_as_admin
  end

  describe 'GET index' do
    it 'assigns all users as @users' do
      user = User.create! valid_attributes
      get :index, {}
      assigns(:users).should eq( User.all | [user])
    end
  end

  describe 'GET show' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :show, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe 'GET new' do
    it 'assigns new user as @user' do
      get :new, {}
      assigns(:user).should be_a_new(User)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested user as @user' do
      user = User.create! valid_attributes
      get :edit, {:id => user.to_param}
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, {:user => valid_attributes}
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => valid_attributes}
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the users list" do
        post :create, {:user => valid_attributes}
        response.should redirect_to(users_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => {}}
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => {}}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = User.create! valid_attributes
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, {:id => user.to_param, :user => {'these' => 'params'}}
      end

      it "assigns the requested user as @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}
        response.should redirect_to(user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => {}}
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => {}}
        response.should render_template("edit")
      end
    end
  end

  describe "User Reactivate/Deactivate" do
    it "deactivate a user" do
      user = User.create! valid_attributes
      put :deactivate, {:id => user.to_param}
      response.should redirect_to(users_url)
      flash[:notice].should eq(nil)

      assigns(:user).deleted_at.should_not eq(nil)

    end

    it "reactivate a user" do
      user = User.create! valid_attributes.merge(:deleted_at => Time.current)
      put :reactivate, {:id => user.to_param}
      response.should redirect_to(users_url)
      flash[:notice].should eq(nil)

      assigns(:user).deleted_at.should eq(nil)

    end

  end

end
