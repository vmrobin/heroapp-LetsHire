require 'spec_helper'

describe User do
  it 'has a valid factory' do
    FactoryGirl.create(:user).should be_valid
  end

  it 'requires email to be present' do
    FactoryGirl.build(:user, :email => nil).should_not be_valid
  end

  it 'requires email to be unique' do
    user = FactoryGirl.create(:user)
    FactoryGirl.build(:user, :email => user.email).should_not be_valid
  end

  it 'creates non-admin user by default' do
    FactoryGirl.build(:user).admin?.should be_false
  end

  it 'creates admin user' do
    User.new_admin.admin?.should be_true
  end
end
