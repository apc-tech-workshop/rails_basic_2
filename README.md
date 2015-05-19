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