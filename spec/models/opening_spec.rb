require 'spec_helper'

describe Opening do
  it 'has a valid factory' do
    FactoryGirl.create(:opening).should be_valid
  end

  it 'requires a title' do
    FactoryGirl.build(:opening, :title => nil).should_not be_valid
  end

end
