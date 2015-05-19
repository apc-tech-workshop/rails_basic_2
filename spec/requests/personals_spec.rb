require 'rails_helper'

RSpec.describe "Personals", type: :request do
  describe "GET /personals" do
    it "works! (now write some real specs)" do
      get personals_path
      expect(response).to have_http_status(200)
    end
  end
end
