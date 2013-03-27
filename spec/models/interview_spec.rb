require 'spec_helper'

describe Interview do
  it 'has a valid interview' do
    FactoryGirl.build(:interview).should be_valid
  end

  it 'requires modality to be present' do
    FactoryGirl.build(:interview, :modality => nil).should_not be_valid
  end

  it 'requires title to be present' do
    FactoryGirl.build(:interview, :title => nil).should_not be_valid
  end

  it 'requires scheduled_at to be present' do
    FactoryGirl.build(:interview, :scheduled_at => nil).should_not be_valid
  end

  it 'requires modality to be valid values' do
    FactoryGirl.build(:interview, :modality => 'Invalid Value').should_not be_valid
  end

  it 'requires status to be valid values' do
    FactoryGirl.build(:interview, :status => 'Invalid Status').should_not be_valid
  end
end
