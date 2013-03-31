require 'spec_helper'

describe Opening do
  it 'has a valid factory' do
    FactoryGirl.create(:opening).should be_valid
  end

  it 'requires a title' do
    FactoryGirl.build(:opening, :title => nil).should_not be_valid
  end

  it 'requires a valid hiring manager if set' do
    opening = FactoryGirl.build(:opening, :hiring_manager_id => 100)
    opening.should_not be_valid
    opening.errors[:hiring_manager_id].join("; ").should == "isn't a hiring manager"
  end

  it 'requires a valid recruiter if set' do
    opening = FactoryGirl.build(:opening, :recruiter_id => 100)
    opening.should_not be_valid
    opening.errors[:recruiter_id].join("; ").should == "isn't a recruiter"
  end

end
