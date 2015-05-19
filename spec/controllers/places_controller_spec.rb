require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe PlacesController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Place. As you add validations to Place, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # PlacesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET #index" do
    it "assigns all places as @places" do
      place = Place.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:places)).to eq([place])
    end
  end

  describe "GET #show" do
    it "assigns the requested place as @place" do
      place = Place.create! valid_attributes
      get :show, {:id => place.to_param}, valid_session
      expect(assigns(:place)).to eq(place)
    end
  end

  describe "GET #new" do
    it "assigns a new place as @place" do
      get :new, {}, valid_session
      expect(assigns(:place)).to be_a_new(Place)
    end
  end

  describe "GET #edit" do
    it "assigns the requested place as @place" do
      place = Place.create! valid_attributes
      get :edit, {:id => place.to_param}, valid_session
      expect(assigns(:place)).to eq(place)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Place" do
        expect {
          post :create, {:place => valid_attributes}, valid_session
        }.to change(Place, :count).by(1)
      end

      it "assigns a newly created place as @place" do
        post :create, {:place => valid_attributes}, valid_session
        expect(assigns(:place)).to be_a(Place)
        expect(assigns(:place)).to be_persisted
      end

      it "redirects to the created place" do
        post :create, {:place => valid_attributes}, valid_session
        expect(response).to redirect_to(Place.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved place as @place" do
        post :create, {:place => invalid_attributes}, valid_session
        expect(assigns(:place)).to be_a_new(Place)
      end

      it "re-renders the 'new' template" do
        post :create, {:place => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => new_attributes}, valid_session
        place.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested place as @place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => valid_attributes}, valid_session
        expect(assigns(:place)).to eq(place)
      end

      it "redirects to the place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => valid_attributes}, valid_session
        expect(response).to redirect_to(place)
      end
    end

    context "with invalid params" do
      it "assigns the place as @place" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => invalid_attributes}, valid_session
        expect(assigns(:place)).to eq(place)
      end

      it "re-renders the 'edit' template" do
        place = Place.create! valid_attributes
        put :update, {:id => place.to_param, :place => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested place" do
      place = Place.create! valid_attributes
      expect {
        delete :destroy, {:id => place.to_param}, valid_session
      }.to change(Place, :count).by(-1)
    end

    it "redirects to the places list" do
      place = Place.create! valid_attributes
      delete :destroy, {:id => place.to_param}, valid_session
      expect(response).to redirect_to(places_url)
    end
  end

  describe "POST #search" do
    let(:params){
      {
        personal_id: 1,
        name: "肉の万世 秋葉原本店",
        address: "東京都千代田区神田須田町２−２１",
      }
    }

    let(:expect_json){
      {
        result: {
          status: "ok",
          msg: "",
          place: {
            id: 1,
            personal_id: 1,
            name: "肉の万世 秋葉原本店",
            address: "東京都千代田区神田須田町２−２１",
            latitude: 35.696361,
            longitude: 139.771072,
          }
        }
      }.to_json
    }

    before do
      FactoryGirl.define do
          factory :personal_1, class: Personal do
              id 1
              name "服部"
          end
          FactoryGirl.create(:personal_1)
      end
    end

    before :each do
      post :search, ActionController::Parameters.new({ place: params })
    end

    it "search geocode from human readable address" do
      expect(response.status).to eq(200)

      actual = JSON.parse(response.body)['result']
      expected = JSON.parse(expect_json)['result']

      expect(actual['status']).to eq(expected['status'])
      expect(actual['msg']).to eq(expected['msg'])

      actual_place = actual['place']
      expect_place = expected['place']

      expect(actual_place['id']).to eq(expect_place['id'])
      expect(actual_place['personal_id']).to eq(expect_place['personal_id'])
      expect(actual_place['name']).to eq(expect_place['name'])
      expect(actual_place['address']).to eq(expect_place['address'])
      expect(actual_place['latitude']).to eq(expect_place['latitude'])
      expect(actual_place['longitude']).to eq(expect_place['longitude'])
    end
  end

end
