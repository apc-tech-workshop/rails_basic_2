# sample code for apc rails workshop.

- [api doc & mock](http://docs.apcrailsws.apiary.io/)

# topic

- rspec & guard
  - routing
  - controller
    - API
  - model
    - factory_girl_rails
- model
  - model : hoge
    - geocoding
- heroku
  - gitignore

# note

- require : [postman REST client](https://chrome.google.com/webstore/detail/postman-rest-client-packa/fhbjgbiflinjbdggehcddcbncdddomop)

## 1. gem config

```
$ vi ~/.gemrc
```
```
gem: --no-ri --no-rdoc
install: --no-ri --no-rdoc
update: --no-ri --no-rdoc
```

## 2. rspec

```
$ cd apc_rails_ws/
$ bundle exec rails new . --skip-test-unit
$ echo 'vendor/bundle/*' >> .gitignore
$ vi Gemfile
```

```ruby
group :development, :test do
  gem "spring-commands-rspec"

  gem 'rspec-rails'
  gem 'guard-rspec'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
end
```

```
$ bundle install
$ bundle exec rails g rspec:install
$ vi spec/spec_helper.rb
```

## 3. factory_girl_rails and database_cleaner

### factory_girl_rails

> factory_girl is a fixtures replacement with a straightforward definition syntax, support for multiple build strategies (saved instances, unsaved instances, attribute hashes, and stubbed objects), and support for multiple factories for the same class (user, admin_user, and so on), including factory inheritance.


### database_cleaner

> Database Cleaner is a set of strategies for cleaning your database in Ruby.

### config

```ruby
require 'factory_girl'
require 'database_cleaner'

RSpec.configure do |config|
  # append rspec configuration
  config.order = 'random'

  # append factory_girl configuration
  config.use_transactional_fixtures = false
  config.include FactoryGirl::Syntax::Methods
  config.before(:all) do
    FactoryGirl.reload
  end

  # append database_cleaner configuration
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
```

## 4. guard-rspec

```
$ bundle exec guard init rspec
$ bundle exec spring binstub --all
$ vi Guardfile
```

```ruby
guard :rspec, cmd: 'spring rspec -f doc' do
# ..
end
```

```
$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

## 5. confirmation

```
$ bundle exec rails g scaffold personal name:string
$ bundle exec rails g scaffold place personal:references name:string address:string latitude:float longitude:float
```

## 6. delete views spec

- レイアウトのテストも可能だが今回はcontrollerの入出力だけで十分なので削除する

```
$ rm -rf spec/views
```

## 7. run guard

```
$ bundle exec guard
```

> and enter

## 8. edit routing_rspec

```
$ vi spec/routing/places_routing_spec.rb
```

```ruby
it "routes to #search" do
  expect(:post => "/places/search").to route_to("places#search")
end
```

> return to guard and enter

## 9. fix routes.rb 

```
$ vi config/routes.rb
```

```ruby
resources :places do
    collection do
      post 'search'
    end
  end
resources :personals
```

> confirm routes

```
$ bundle exec rake routes | grep search
```

## 10. edit place_controller.rb

```
$ vi app/controllers/places_controller.rb
```

```ruby
def search
  out = {}
  render json: out, status: :ok
end
```

## 11. fix place_controller_rspec.rb with factory_girl

- see : [api](http://docs.apcrailsws.apiary.io/)

```
$ vi spec/controllers/places_controller_spec.rb
```

```ruby
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
        personal_name: "服部",
        place: {
          id: 1,
          personal_id: 1,
          name: "肉の万世 秋葉原本店",
          address: "東京都千代田区神田須田町２−２１",
          latitude: 35.6963613,
          longitude: 139.7710718,
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
    expect(actual['personal_name']).to eq(expected['personal_name'])

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
```

## 12. fix place_controller.rb

```
$ vi app/controllers/places_controller.rb
```

```ruby
def search
  personal_id = place_params[:personal_id]

  if Personal.find(personal_id)
    place_name = place_params[:name]
    place_address = place_params[:address]

    place = Place.new
    place.personal_id = personal_id
    place.name = place_name
    place.address = place_address
    place.latitude = 35.6963613 # TODO 後でgeocoderで実測値を設定させる
    place.longitude = 139.7710718 # TODO 後でgeocoderで実測値を設定させる
    place.save!

    out = Jbuilder.encode do |json|
      json.result do
        json.status "ok"
        json.msg ""
        json.personal_name Personal.find(personal_id).name
        json.place place
      end
    end
    render json: out, status: :ok
  else
    out = Jbuilder.encode do |json|
      json.result do
        json.status "error"
        json.msg "undefined personal data"
      end
    end
    render json: out, status: :unprocessable_entity
  end
end
```

## 13. fix application_controller.rb

```
$ vi app/controller/application_controller.rb
```

```ruby
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
end
```

## 14. add geocoder

- [ref1](http://ja.asciicasts.com/episodes/273-geocoder)
- [ref2](http://www.synbioz.com/blog/search_by_location_with_geocoder)

```
$ vi Gemfile
```

```ruby
gem 'geocoder'

group :development, :test do
  #...
end
```

```
$ vi config/initializers/geocoder.rb
```

```ruby
Geocoder.configure(
  # geocoding service
  lookup: :google,

  # geocoding service request timeout (in seconds)
  timeout: 3,

  # default units
  units: :km
)
```

```
$ vi app/models/place.rb
```

```ruby
class Place < ActiveRecord::Base
  belongs_to :personal
  
  attr_accessor :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode
end
```

## 15. client test

```
POST http://localhost:3000/places/search
{
    "personal_id" : 1,
    "name" : "肉の万世 秋葉原本店",
    "address" : "東京都千代田区神田須田町２−２１"
}

{"result":{"status":"ok","msg":"","personal_name":"服部","place":{"id":4,"personal_id":1,"name":"肉の万世 秋葉原本店","address":"東京都千代田区神田須田町２−２１","latitude":35.6963613,"longitude":139.7710718,"created_at":"2015-05-19T14:03:02.904Z","updated_at":"2015-05-19T14:03:02.904Z"}}}
```


