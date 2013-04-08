require 'spec_helper'
require 'cancan/matchers'

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

  it 'requires email to be good format' do
    FactoryGirl.build(:user, :email => 'user@local').should_not be_valid
  end

  it 'creates non-admin user by default' do
    FactoryGirl.build(:user).admin?.should be_false
  end

  it 'creates admin user' do
    User.new_admin.admin?.should be_true
  end

  describe 'abilities' do
    subject { ability }
    let(:ability) { Ability.new(user) }
    let(:user) { nil }

    context 'admin user' do
      let(:user) { User.new_admin }
      it{ should be_able_to(:manage, Interview.new)}
      it{ should be_able_to(:manage, User.new)}
      it{ should be_able_to(:manage, Opening.new)}
    end

    context 'normal user' do
      let(:user) { FactoryGirl.build(:user)}
      it{ should_not be_able_to(:manage, Interview.new)}
      it{ should_not be_able_to(:manage, User.new)}
      it{ should_not be_able_to(:manage, Opening.new)}
    end

    context 'recruiter' do
      let(:user) do
        user = FactoryGirl.build(:user)
        user.add_role('recruiter')
        user
      end
      it{ should be_able_to :manage, Interview.new }
      it{ should be_able_to :manage, Opening.new }
      it{ should_not be_able_to :manage, User.new }
    end

    context 'hiringmanager' do
      let(:user) do
        user = FactoryGirl.build(:user)
        user.add_role('hiringmanager')
        user
      end
      it{ should_not be_able_to :manage, Interview.new }
      it{ should be_able_to :update, Interview.new }
      it{ should be_able_to :manage, Opening.new }
      it{ should_not be_able_to :manage, User.new }
    end

    context 'interviewer' do
      let(:user) do
        user = FactoryGirl.build(:user)
        user.add_role('interviewer')
        user
      end
      it{ should_not be_able_to :manage, Interview.new }
      it{ should be_able_to :update, Interview.new }
      it{ should_not be_able_to :manage, User.new }
    end

    context 'mixed roles' do
      let(:user) do
        user = FactoryGirl.build(:user)
        user.add_role('interviewer')
        user.add_role('hiringmanager')
        user
      end
      it{ should_not be_able_to :manage, Interview.new }
      it{ should be_able_to :update, Interview.new }
      it{ should be_able_to :manage, Opening.new }
      it{ should_not be_able_to :manage, User.new }
    end
  end

end
