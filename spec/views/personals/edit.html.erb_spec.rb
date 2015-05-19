require 'rails_helper'

RSpec.describe "personals/edit", type: :view do
  before(:each) do
    @personal = assign(:personal, Personal.create!(
      :name => "MyString"
    ))
  end

  it "renders the edit personal form" do
    render

    assert_select "form[action=?][method=?]", personal_path(@personal), "post" do

      assert_select "input#personal_name[name=?]", "personal[name]"
    end
  end
end
