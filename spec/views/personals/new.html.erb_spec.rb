require 'rails_helper'

RSpec.describe "personals/new", type: :view do
  before(:each) do
    assign(:personal, Personal.new(
      :name => "MyString"
    ))
  end

  it "renders new personal form" do
    render

    assert_select "form[action=?][method=?]", personals_path, "post" do

      assert_select "input#personal_name[name=?]", "personal[name]"
    end
  end
end
