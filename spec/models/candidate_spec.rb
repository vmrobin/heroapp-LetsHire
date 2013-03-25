require 'spec_helper'

describe Candidate do
  it 'has a valid factory' do
    FactoryGirl.create(:candidate).should be_valid
  end

  it 'requires name to be present' do
    FactoryGirl.build(:candidate, :name => nil).should_not be_valid
  end

  it 'requires email to be present' do
    FactoryGirl.build(:candidate, :email => nil).should_not be_valid
  end
end
