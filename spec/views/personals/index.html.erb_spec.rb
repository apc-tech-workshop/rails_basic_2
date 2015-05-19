require 'rails_helper'

RSpec.describe "personals/index", type: :view do
  before(:each) do
    assign(:personals, [
      Personal.create!(
        :name => "Name"
      ),
      Personal.create!(
        :name => "Name"
      )
    ])
  end

  it "renders a list of personals" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
