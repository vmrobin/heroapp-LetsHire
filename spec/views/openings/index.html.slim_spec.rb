require 'spec_helper'

require 'will_paginate/array'

describe "openings/index" do
  before(:each) do
    assign(:openings, [
      stub_model(Opening,
        :title => "Title"
      ),
      stub_model(Opening,
                 :title => "Title"
      ),
      stub_model(Opening,
                 :title => "Title"
      ),
      stub_model(Opening,
        :title => "Title"
      )
    ].paginate(:page => 1, :per_page => 2))
  end

  it "renders a list of openings" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
  end
end
