require 'spec_helper'

describe Interview do
  it 'has a valid interview' do
    FactoryGirl.build(:interview).should be_valid
  end

  it 'requires type to be present' do
    FactoryGirl.build(:interview, :type => nil).should_not be_valid
  end

  it 'requires title to be present' do
    FactoryGirl.build(:interview, :title => nil).should_not be_valid
  end

  it 'requires scheduled_at to be present' do
    FactoryGirl.build(:interview, :scheduled_at => nil).should_not be_valid
  end
end
