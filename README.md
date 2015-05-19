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

## gem config

```
$ vi ~/.gemrc
```
```
gem: --no-ri --no-rdoc
install: --no-ri --no-rdoc
update: --no-ri --no-rdoc
```

## rspec

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

## factory_girl_rails

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

## guard-rspec

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
$ bundle exec guard
```

## confirmation

```
$ bundle exec rails g scaffold personal name:string
$ bundle exec rails g scaffold place personal:references name:string address:string latitude:float longitude:float
```

## run guard

## edit routing_rspec

## fix route.rb 

## edit place_controller.rb

## fix place_controller_rspec.rb with factory_girl

## fix place_controller.rb

## fix application_controller.rb

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

## add geocoder

- [ref1](http://ja.asciicasts.com/episodes/273-geocoder)
- [ref2](http://www.synbioz.com/blog/search_by_location_with_geocoder)

```
$ vi Gemfile
$ bundle install
```

```ruby
gem 'geocoder'

group :development, :test do
...
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
$ vi app/models/place.ru
```

```ruby
class Place < ActiveRecord::Base
  belongs_to :personal
  
  attr_accessor :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode
end
```

## test

```
POST http://localhost:3000/places/search
{
    "personal_id" : 1,
    "name" : "肉の万世 秋葉原本店",
    "address" : "東京都千代田区神田須田町２−２１"
}

{"result":{"status":"ok","msg":"","personal_name":"服部","place":{"id":4,"personal_id":1,"name":"肉の万世 秋葉原本店","address":"東京都千代田区神田須田町２−２１","latitude":35.6963613,"longitude":139.7710718,"created_at":"2015-05-19T14:03:02.904Z","updated_at":"2015-05-19T14:03:02.904Z"}}}
```


