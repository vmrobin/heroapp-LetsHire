require 'spec_helper'

describe OpeningCandidate do
  it "has a valid opening_candidate" do
    FactoryGirl.build(:opening_candidate).should be_valid
  end

  it "requires candidate_id to be present" do
    FactoryGirl.build(:opening_candidate, :candidate_id => nil).should_not be_valid
  end

  it "requires opening_id to be present" do
    FactoryGirl.build(:opening_candidate, :opening_id => nil).should_not be_valid
  end
end
