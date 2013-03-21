require 'spec_helper'

describe "openings/show" do
  before(:each) do
    @opening = assign(:opening, stub_model(Opening,
      :title => "Title"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Title/)
  end
end
