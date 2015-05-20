[TOC]

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

## 0. bundle exec rails s までの道のり

- [bundler](http://qiita.com/znz/items/5471e5826fde29fa9a80)

```
$ gem install bundler
$ gem list | grep bundler

$ mkdir apc_rails_ws
$ cd apc_rails_ws

$ bundle init
$ vi Gemfile
```

```ruby
source 'https://rubygems.org'

gem 'rails'
```

```
$ bundle install --path=vendor/bundle
....
$ bundle exec rails new .
$ vi Gemfile
```

- use `sqlite3`

```ruby
source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end
```

```
$ bundle install
$ bundle clean
$ bundle exec rails s

.. 他のshellから下記を実行

$ curl -X GET 'http://localhost:3000/'
```

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
source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.1'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem "spring-commands-rspec" # append

  gem 'rspec-rails' # append
  gem 'guard-rspec' # append
  gem 'factory_girl_rails' # append
  gem 'database_cleaner' # append

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
  
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.order = :random

  # append factory_girl configuration
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

## 5. confirmation

### ER

| Personal    |
| ----------- |
| id          |
| name:string |
| created_at  |
| upadted_at  |

| Place               |
| ------------------- |
| id                  |
| personal:reference  |
| name:string         |
| address:string      |
| latitude:float      |
| longitude:float     |
| created_at          |
| upadted_at          |


```
Personal -- 1:* -- Place
```

```
$ bundle exec rails g scaffold personal name:string
$ bundle exec rails g scaffold place personal:references name:string address:string latitude:float longitude:float

$ bundle exec rake db:create
$ bundle exec rake db:migrate
```

### 間違えたら

```
$ bundle exec rails g scaffold personal name:string

                    |
                    V

$ bundle exec rails d scaffold personal name:string
```

```
$ bundle exec rails g scaffold personal name:string
      invoke  active_record
      create    db/migrate/20150520135822_create_personals.rb
      create    app/models/personal.rb
      invoke    test_unit
      create      test/models/personal_test.rb
      create      test/fixtures/personals.yml
      invoke  resource_route
       route    resources :personals
      invoke  scaffold_controller
      create    app/controllers/personals_controller.rb
      invoke    erb
      create      app/views/personals
      create      app/views/personals/index.html.erb
      create      app/views/personals/edit.html.erb
      create      app/views/personals/show.html.erb
      create      app/views/personals/new.html.erb
      create      app/views/personals/_form.html.erb
      invoke    test_unit
      create      test/controllers/personals_controller_test.rb
      invoke    helper
      create      app/helpers/personals_helper.rb
      invoke      test_unit
      invoke    jbuilder
      create      app/views/personals/index.json.jbuilder
      create      app/views/personals/show.json.jbuilder
      invoke  assets
      invoke    coffee
      create      app/assets/javascripts/personals.coffee
      invoke    scss
      create      app/assets/stylesheets/personals.scss
      invoke  scss
      create    app/assets/stylesheets/scaffolds.scss

$ bundle exec rails d scaffold personal name:string
      invoke  active_record
      remove    db/migrate/20150520135822_create_personals.rb
      remove    app/models/personal.rb
      invoke    test_unit
      remove      test/models/personal_test.rb
      remove      test/fixtures/personals.yml
      invoke  resource_route
       route    resources :personals
      invoke  scaffold_controller
      remove    app/controllers/personals_controller.rb
      invoke    erb
      remove      app/views/personals
      remove      app/views/personals/index.html.erb
      remove      app/views/personals/edit.html.erb
      remove      app/views/personals/show.html.erb
      remove      app/views/personals/new.html.erb
      remove      app/views/personals/_form.html.erb
      invoke    test_unit
      remove      test/controllers/personals_controller_test.rb
      invoke    helper
      remove      app/helpers/personals_helper.rb
      invoke      test_unit
      invoke    jbuilder
      remove      app/views/personals
      remove      app/views/personals/index.json.jbuilder
      remove      app/views/personals/show.json.jbuilder
      invoke  assets
      invoke    coffee
      remove      app/assets/javascripts/personals.coffee
      invoke    scss
      remove      app/assets/stylesheets/personals.scss
      invoke  scss
```

- rspecなどが対応するmodel,controller,view,routeその他もろもろ用に生成されるのが確認出来る
- ついでにmodelも確認してみる
  - id,created_at, updated_atは自動生成される上に、railsの内部で利用される暗黙の了解なのでなるべく指定しない方がいい
　- `db/migrate/*_create_places.rb`を参照すると`references`と書かれているが、sqlite3を他のアプリで開くとpersonal_id:integerとなっているのが分かる。
  - 手動で personal_id:integerと書いて、`app/models/place.rb`に`belongs_to :personal`と書けばjoinの準備がやっとできる。
  - しかし、今回はscaffoldの時に`personal:references`を指定したのでそれらは全て生成済みだ。

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

### rspec 構造

```ruby
describe クラス名, type: railsクラスのタイプ(:controllerなど) do
  describe "説明的文字列" do
    let(:変数名){
      # ruby文法の式や値など
      # 宣言が :hoge なら、 読み込みは hoge
    }

    before do
      # 直上のdescribeのスコープ内で最初に１度だけ実行するコード
      # 他に after などがある
    end

    before :each do 
      # 直上のdescribeのスコープ内でitが検証される毎に直前に実行するコード
      # 他に after :each などがある
    end

    it "説明的文字列" do  
      expect(実測値).to eq(期待値)
      # .to以外に null判定などいくつかある
      # eq以外に 正規表現などいくつかある
    end 
  end
end
```

### factory girl 構造

```ruby
FactoryGirl.define do
  # 以降 factory ** do -- end のブロックを書き連ねて行く
  factory :変数名, class: modelのクラス名 do
    # :変数名はprojectを通して常にuniqueにした方がいい
    # 複数のrspecをコマンドラインで実行するときの名前衝突を回避する目的
    # spec/factoriesに切り出しても良いが、２枚のファイルを見比べてコードを書くのは大変なので冗長でも１枚に収めたほうが楽
    カラム名 値
  end
  FactoryGirl.create(:変数名)
  # .createの他に.buildなどがある
end
# FactoryGirlによって追加されたダミーデータは
# database_cleanerにより、スコープを抜けた時に対象のmodelはtruncateされる
# テスト毎に作成したダミーデータが衝突しなくなり互いのテストの依存度がゼロになる
```

### sample code

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
require 'jbuilder'

class PlacesController < ApplicationController
  before_action :set_place, only: [:show, :edit, :update, :destroy]

  #... 

  def search
    personal_id = place_params[:personal_id]
    personal = Personal.find(personal_id)

    if personal
      place_name = place_params[:name]
      place_address = place_params[:address]

      place = Place.new
      place.personal_id = personal.id
      place.name = place_name
      place.address = place_address
      place.latitude = 35.6963613 # TODO 後でgeocoderで実測値を設定させる
      place.longitude = 139.7710718 # TODO 後でgeocoderで実測値を設定させる
      place.save!

      out = Jbuilder.encode do |json|
        json.result do
          json.status "ok"
          json.msg ""
          json.personal_name place.personal.name
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

  private
  # Use callbacks to share common setup or constraints between actions.
    def set_place
      @place = Place.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def place_params
      params.require(:place).permit(:personal_id, :name, :address, :latitude, :longitude)
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

## 15. fix place_controller (latitude, longitude)

```
$ vi app/controllers/places_controller.rb
```

```ruby
place = Place.new
place.personal_id = personal.id
place.name = place_name
place.address = place_address
#place.latitude = 35.6963613
#place.longitude = 139.7710718
place.save!
```

## 16. client test

- ブラウザでデータを１件だけ作成
  - [local](http://localhost:3000/personals)


```
POST http://localhost:3000/places/search
{
    "personal_id" : 1,
    "name" : "肉の万世 秋葉原本店",
    "address" : "東京都千代田区神田須田町２−２１"
}

response:

{
  "result": {
    "status": "ok",
    "msg": "",
    "personal_name": "服部",
    "place": {
      "id": 1,
      "personal_id": 1,
      "name": "肉の万世 秋葉原本店",
      "address": "東京都千代田区神田須田町２−２１",
      "latitude": 35.6963613,
      "longitude": 139.7710718,
      "created_at": "2015-05-19T14:03:02.904Z",
      "updated_at": "2015-05-19T14:03:02.904Z"
    }
  }
}
```

### エラーが出る場合

- `ActionController::ParameterMissing in PlacesController#search`が出る場合の対処法
  - HTTP Headerに `Content-Type: application/json` を指定する事で回避可能
