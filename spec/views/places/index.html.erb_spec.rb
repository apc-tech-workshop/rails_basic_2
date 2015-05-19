require 'rails_helper'

RSpec.describe "places/index", type: :view do
  before(:each) do
    assign(:places, [
      Place.create!(
        :personal => nil,
        :name => "Name",
        :address => "Address",
        :latitude => 1.5,
        :longitude => 1.5
      ),
      Place.create!(
        :personal => nil,
        :name => "Name",
        :address => "Address",
        :latitude => 1.5,
        :longitude => 1.5
      )
    ])
  end

  it "renders a list of places" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 4
    assert_select "tr>td", :text => 1.5.to_s, :count => 4
  end
end
